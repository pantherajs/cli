CREATE OR REPLACE FUNCTION delete_category(requested_id INTEGER, client_token UUID)
RETURNS TABLE (
  status_code INTEGER
) AS $delete_category$
  WITH authorized_user AS (
    SELECT
      requested_id AS category_id
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
    INNER JOIN permission AS can_delete_category
      ON alias.role_id = can_delete_category.role_id
      AND can_delete_category.permission_type = 'DELETE'
      AND can_delete_category.resource_type = 'CATEGORY'
      AND can_delete_category.enabled = TRUE
    WHERE access_token.token = client_token
    LIMIT 1
  ), delete_category AS (
    DELETE FROM category
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
    CASE WHEN delete_category.category_id IS NOT NULL THEN
      response.status_code
    ELSE
      401
    END AS status_code
  FROM response
  LEFT JOIN delete_category
    ON TRUE
  LIMIT 1;
$delete_category$
  VOLATILE
  LANGUAGE sql;
