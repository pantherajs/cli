CREATE OR REPLACE FUNCTION delete_alias()
RETURNS TRIGGER AS
$delete_alias$
BEGIN
  UPDATE category_viewable_mat SET
    expiry = '-infinity'
  WHERE category_viewable_mat.account_id = OLD.account_id
    AND OLD.modified <= expiry;

  RETURN OLD;
END;
$delete_alias$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER delete_alias AFTER DELETE ON alias
  FOR EACH ROW EXECUTE PROCEDURE delete_alias();
