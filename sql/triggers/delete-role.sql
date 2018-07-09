CREATE OR REPLACE FUNCTION delete_role()
RETURNS TRIGGER AS
$delete_role$
BEGIN
  IF (OLD.name IN ('Administrator', 'Member', 'Character', 'Guest')) THEN
    RAISE EXCEPTION 'cannot delete default role % with id %', OLD.name, OLD.id;
  END IF;

  RETURN OLD;
END;
$delete_role$
  LANGUAGE plpgsql;

CREATE TRIGGER prevent_default_row_delete BEFORE DELETE ON role
  FOR EACH ROW EXECUTE PROCEDURE delete_role();
