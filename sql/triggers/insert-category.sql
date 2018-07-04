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

  INSERT INTO permission (role_id, permission_type, resource_type, state)
    SELECT
      role.id    AS role_id,
      'READ'     AS permission_type,
      'CATEGORY' AS resource_type,
      FALSE      AS state
    FROM role;

  INSERT INTO category_permission (permission_id, category_id)
    SELECT
      permission.id AS permission_id,
      NEW.id        AS category_id
    FROM permission
    WHERE permission.id NOT IN (SELECT permission_id FROM category_permission)
      AND permission.resource_type = 'CATEGORY'
      AND permission.permission_type = 'READ';

  RETURN NEW;
END;
$insert_category$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER insert_category AFTER INSERT ON category
  FOR EACH ROW EXECUTE PROCEDURE insert_category();
