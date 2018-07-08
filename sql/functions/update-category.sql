CREATE OR REPLACE FUNCTION update_category(
  category_id       INTEGER,
  category_name     VARCHAR,
  category_sort_key INTEGER,
  client_token      UUID
) RETURNS TABLE (
  status_code INTEGER
) AS $update_category$
  WITH authorized_user AS (
    SELECT
      category_id
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
    INNER JOIN permission AS can_update_category
      ON alias.role_id = can_update_category.role_id
      AND can_update_category.permission_type = 'UPDATE'
      AND can_update_category.resource_type = 'CATEGORY'
      AND can_update_category.enabled = TRUE
    WHERE access_token.token = client_token
    LIMIT 1
  ), update_category AS (
    UPDATE category SET
      name     = COALESCE(category_name, name),
      sort_key = COALESCE(category_sort_key, sort_key)
    WHERE id = (
      SELECT
        category_id
      FROM authorized_user
    )
    RETURNING
      id AS category_id
  ), response (status_code) AS (
    VALUES (204)
  )
  SELECT
    CASE WHEN update_category.category_id IS NOT NULL THEN
      response.status_code
    ELSE
      401
    END AS status_code
  FROM response
  LEFT JOIN update_category
    ON TRUE
  LIMIT 1;
$update_category$
  VOLATILE
  LANGUAGE sql;
