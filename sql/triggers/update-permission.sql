CREATE OR REPLACE FUNCTION update_permission()
RETURNS TRIGGER AS
$update_permission$
BEGIN
  IF (NEW.permission_type = 'READ' AND OLD.enabled <> NEW.enabled) THEN
    IF (NEW.resource_type = 'CATEGORY') THEN
      UPDATE category_viewable_mat SET
        expiry = '-infinity'
      WHERE category_viewable_mat.category_id = (
        SELECT
          category_permission.category_id
        FROM category_permission
        WHERE category_permission.permission_id = NEW.id
      )
        AND NEW.modified <= expiry;
    END IF;

    IF (NEW.resource_type = 'FORUM') THEN
      UPDATE forum_viewable_mat SET
        expiry = '-infinity'
      WHERE forum_viewable_mat.forum_id = (
        SELECT
          forum_permission.forum_id
        FROM forum_permission
        WHERE forum_permission.permission_id = NEW.id
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
