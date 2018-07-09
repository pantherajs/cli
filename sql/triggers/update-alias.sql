CREATE OR REPLACE FUNCTION update_alias()
RETURNS TRIGGER AS
$update_alias$
BEGIN
  IF (OLD.account_id <> NEW.account_id) THEN
    UPDATE category_viewable_mat SET
      expiry = NEW.modified
    WHERE category_viewable_mat.account_id IN (OLD.account_id, NEW.account_id)
      AND NEW.modified <= category_viewable_mat.expiry;

    UPDATE forum_viewable_mat SET
      expiry = NEW.modified
    WHERE forum_viewable_mat.account_id IN (OLD.account_id, NEW.account_id)
      AND NEW.modified <= forum_viewable_mat.expiry;
  END IF;

  RETURN NEW;
END;
$update_alias$
  VOLATILE
  LANGUAGE plpgsql;

CREATE TRIGGER update_alias AFTER UPDATE ON alias
  FOR EACH ROW EXECUTE PROCEDURE update_alias();
