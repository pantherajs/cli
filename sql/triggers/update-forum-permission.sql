CREATE OR REPLACE FUNCTION update_forum_permission()
RETURNS TRIGGER AS
$update_forum_permission$
BEGIN
  IF (OLD.can_view <> NEW.can_view) THEN
    UPDATE forum_viewable_mat SET
      expiry = '-infinity'
    WHERE forum_id = NEW.forum_id
      AND NEW.modified <= expiry;
  END IF;

  RETURN NEW;
END;
$update_forum_permission$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER update_forum_permission AFTER UPDATE ON forum_permission
  FOR EACH ROW EXECUTE PROCEDURE update_forum_permission();
