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

  INSERT INTO forum_viewable_mat (account_id, forum_id, expiry)
    SELECT
      NEW.id,
      forum.id,
      NEW.created
    FROM forum;

  RETURN NEW;
END;
$insert_account$
  LANGUAGE plpgsql;

CREATE TRIGGER insert_account AFTER INSERT ON account
  FOR EACH ROW EXECUTE PROCEDURE insert_account();
