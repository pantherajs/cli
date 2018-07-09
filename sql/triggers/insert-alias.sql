CREATE OR REPLACE FUNCTION insert_alias()
RETURNS TRIGGER AS
$insert_alias$
BEGIN
  INSERT INTO alias_statistics_mat (alias_id)
    VALUES (NEW.id);

  UPDATE category_viewable_mat SET
    expiry = NEW.created
  WHERE category_viewable_mat.account_id = NEW.account_id;

  RETURN NEW;
END;
$insert_alias$
  VOLATILE
  LANGUAGE plpgsql;

CREATE TRIGGER insert_alias AFTER INSERT ON alias
  FOR EACH ROW EXECUTE PROCEDURE insert_alias();
