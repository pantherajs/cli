CREATE OR REPLACE FUNCTION insert_category()
RETURNS TRIGGER AS
$insert_category$
BEGIN
  INSERT INTO category_viewable_mat (account_id, category_id, expiry)
    SELECT
      account.id,
      NEW.id,
      NEW.created
    FROM account;

  INSERT INTO category_permission(category_id, role_id)
    SELECT
      NEW.id,
      role.id
    FROM role;

  RETURN NEW;
END;
$insert_category$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER insert_category AFTER INSERT ON category
  FOR EACH ROW EXECUTE PROCEDURE insert_category();
