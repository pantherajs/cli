CREATE OR REPLACE FUNCTION update_alias()
RETURNS TRIGGER AS
$update_alias$
BEGIN
  IF (OLD.account_id <> NEW.account_id) THEN
    UPDATE category_viewable_mat SET
      expiry = NEW.modified
    WHERE account_id IN (OLD.account_id, NEW.account_id)
      AND NEW.modified <= expiry;
  END IF;

  RETURN NEW;
END;
$update_alias$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER update_alias AFTER UPDATE ON alias
  FOR EACH ROW EXECUTE PROCEDURE update_alias();
