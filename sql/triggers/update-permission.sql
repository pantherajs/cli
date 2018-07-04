CREATE OR REPLACE FUNCTION update_permission()
RETURNS TRIGGER AS
$update_permission$
BEGIN
  IF (NEW.permission_type = 'READ' AND OLD.state <> NEW.state) THEN
    IF (NEW.resource_type = 'CATEGORY') THEN
      UPDATE category_viewable_mat SET
        expiry = '-infinity'
      WHERE category_viewable_mat.category_id = (
        SELECT
          permission_category.category_id
        FROM permission_category
        WHERE permission_category.permission_id = NEW.id
      )
        AND NEW.modified <= expiry;
    END IF;

    IF (NEW.resource_type = 'FORUM') THEN
      UPDATE forum_viewable_mat SET
        expiry = '-infinity'
      WHERE forum_viewable_mat.forum_id = (
        SELECT
          permission_forum.forum_id
        FROM permission_forum
        WHERE permission_forum.permission_id = NEW.id
      )
        AND NEW.modified <= expiry;
    END IF;
  END IF;

  RETURN NEW;
END;
$update_permission$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER update_permission AFTER UPDATE ON permission
  FOR EACH ROW EXECUTE PROCEDURE update_permission();
