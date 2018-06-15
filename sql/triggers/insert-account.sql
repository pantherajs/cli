CREATE OR REPLACE FUNCTION insert_account()
RETURNS TRIGGER AS
$insert_account$
BEGIN
  INSERT INTO category_viewable_mat (account_id, category_id, expiry)
  SELECT
    NEW.id,
    category.id,
    NEW.created
  FROM category;

  RETURN NEW;
END;
$insert_account$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER insert_account AFTER INSERT ON account
  FOR EACH ROW EXECUTE PROCEDURE insert_account();
