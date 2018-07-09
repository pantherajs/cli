CREATE OR REPLACE FUNCTION delete_forum(
  requested_id INTEGER,
  client_token UUID
) RETURNS TABLE (
  status_code INTEGER
) AS $delete_forum$
  WITH authorized_user AS (
    SELECT
      requested_id AS forum_id
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
    INNER JOIN permission AS can_delete_forum
      ON alias.role_id = can_delete_forum.role_id
      AND can_delete_forum.permission_type = 'DELETE'
      AND can_delete_forum.resource_type = 'FORUM'
      AND can_delete_forum.enabled = TRUE
    WHERE access_token.token = client_token
    LIMIT 1
  ), delete_forum AS (
    DELETE FROM forum
    WHERE forum.id = (
      SELECT
        authorized_user.forum_id
      FROM authorized_user
    )
    RETURNING
      forum.id AS forum_id
  ), response (status_code) AS (
    VALUES (204)
  )
  SELECT
    CASE WHEN delete_forum.forum_id IS NOT NULL THEN
      response.status_code
    ELSE
      401
    END AS status_code
  FROM response
  LEFT JOIN delete_forum
    ON TRUE
  LIMIT 1;
$delete_forum$
  VOLATILE
  LANGUAGE sql;
