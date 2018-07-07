CREATE OR REPLACE FUNCTION create_category(category_name VARCHAR, token UUID)
RETURNS TABLE (
  status_code INTEGER,
  json_data   JSONB
) AS $create_category$
  WITH authorized_user AS (
    SELECT
      account.id
    FROM account
    INNER JOIN access_token
      ON account.id = access_token.account_id
    INNER JOIN alias
      ON account.id = alias.account_id
      AND alias.type = 'PRIMARY'
    INNER JOIN permission AS can_access_admin_panel
      ON alias.role_id = can_access_admin_panel.role_id
      AND can_access_admin_panel.permission_type = 'ACCESS'
      AND can_access_admin_panel.resource_type = 'ADMIN_PANEL'
      AND can_access_admin_panel.enabled = TRUE
    INNER JOIN permission AS can_create_category
      ON alias.role_id = can_create_category.role_id
      AND can_create_category.permission_type = 'CREATE'
      AND can_create_category.resource_type = 'CATEGORY'
      AND can_create_category.enabled = TRUE
    WHERE access_token.token = token
    LIMIT 1
  ), insert_category AS (
    INSERT INTO category (name)
      SELECT
        category_name
      FROM authorized_user
    RETURNING
      id AS category_id,
      jsonb_build_object(
        'category_id', id
      )  AS json_data
  ), response (status_code) AS (
    VALUES (201)
  )
  SELECT
    CASE WHEN insert_category.category_id IS NOT NULL THEN
      response.status_code
    ELSE
      401
    END AS status_code,
    insert_category.json_data
  FROM response
  LEFT JOIN insert_category
    ON TRUE
  LIMIT 1;
$create_category$
  VOLATILE
  LANGUAGE sql;
