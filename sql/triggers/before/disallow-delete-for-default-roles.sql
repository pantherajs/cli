CREATE OR REPLACE FUNCTION disallow_delete_for_default_roles()
RETURNS TRIGGER AS
$disallow_delete_for_default_roles$
BEGIN
  IF (OLD.name IN ('Administrator', 'Member', 'Character', 'Guest')) THEN
    RAISE EXCEPTION 'cannot delete default role % with id %', OLD.name, OLD.id;
  END IF;

  RETURN OLD;
END;
$disallow_delete_for_default_roles$
  LANGUAGE plpgsql;

CREATE TRIGGER disallow_delete_for_default_roles BEFORE DELETE ON role
  FOR EACH ROW EXECUTE PROCEDURE disallow_delete_for_default_roles();
