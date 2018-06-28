CREATE OR REPLACE FUNCTION update_category_permission()
RETURNS TRIGGER AS
$update_category_permission$
BEGIN
  IF (OLD.can_view <> NEW.can_view) THEN
    UPDATE category_viewable_mat SET
      expiry = '-infinity'
    WHERE category_id = NEW.category_id
      AND NEW.modified <= expiry;
  END IF;

  RETURN NEW;
END;
$update_category_permission$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER update_category_permission AFTER UPDATE ON category_permission
  FOR EACH ROW EXECUTE PROCEDURE update_category_permission();
