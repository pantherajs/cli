CREATE OR REPLACE FUNCTION delete_category_permission()
RETURNS TRIGGER AS
$delete_category_permission$
BEGIN
  DELETE FROM permission
  WHERE permission.id = OLD.permission_id;

  RETURN OLD;
END;
$delete_category_permission$
  LANGUAGE plpgsql;

CREATE TRIGGER delete_category_permission AFTER DELETE ON category_permission
  FOR EACH ROW EXECUTE PROCEDURE delete_category_permission();
