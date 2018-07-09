CREATE OR REPLACE FUNCTION disallow_update_for_default_roles()
RETURNS TRIGGER AS
$disallow_update_for_default_roles$
BEGIN
  IF (OLD.name IN ('Administrator', 'Member', 'Character', 'Guest')) THEN
    RAISE EXCEPTION 'cannot update default role % with id %', NEW.name, NEW.id;
  END IF;

  RETURN NEW;
END;
$disallow_update_for_default_roles$
  LANGUAGE plpgsql;

CREATE TRIGGER disallow_update_for_default_roles BEFORE UPDATE ON role
  FOR EACH ROW EXECUTE PROCEDURE disallow_update_for_default_roles();
