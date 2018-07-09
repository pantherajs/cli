CREATE OR REPLACE FUNCTION delete_forum_permission()
RETURNS TRIGGER AS
$delete_forum_permission$
BEGIN
  DELETE FROM permission
  WHERE permission.id = OLD.permission_id;

  RETURN OLD;
END;
$delete_forum_permission$
  LANGUAGE plpgsql;

CREATE TRIGGER delete_forum_permission AFTER DELETE ON forum_permission
  FOR EACH ROW EXECUTE PROCEDURE delete_forum_permission();
