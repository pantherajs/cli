CREATE OR REPLACE FUNCTION update_role()
RETURNS TRIGGER AS
$update_role$
BEGIN
  IF (OLD.name IN ('Administrator', 'Member', 'Character', 'Guest')) THEN
    RAISE EXCEPTION 'cannot update default role % with id %', NEW.name, NEW.id;
  END IF;

  RETURN NEW;
END;
$update_role$
  IMMUTABLE
  LANGUAGE plpgsql;

CREATE TRIGGER prevent_default_row_update BEFORE UPDATE ON role
  FOR EACH ROW EXECUTE PROCEDURE update_role();
