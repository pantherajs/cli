CREATE OR REPLACE FUNCTION update_forum(
  forum_id          INTEGER,
  forum_category_id INTEGER,
  forum_name        VARCHAR,
  forum_sort_key    INTEGER,
  token             UUID
) RETURNS TABLE (
  status_code INTEGER
) AS $update_forum$
  WITH authorized_user AS (
    SELECT
      forum_id
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
    INNER JOIN permission AS can_update_forum
      ON alias.role_id = can_update_forum.role_id
      AND can_update_forum.permission_type = 'UPDATE'
      AND can_update_forum.resource_type = 'FORUM'
      AND can_update_forum.enabled = TRUE
    WHERE access_token.token = token
    LIMIT 1
  ), update_forum AS (
    UPDATE forum SET
      category_id = COALESCE(forum_category_id, category_id),
      name        = COALESCE(forum_name, name),
      sort_key    = COALESCE(forum_sort_key, sort_key)
    WHERE id = (
      SELECT
        forum_id
      FROM authorized_user
    )
    RETURNING
      id AS forum_id
  ), response (status_code) AS (
    VALUES (204)
  )
  SELECT
    CASE WHEN update_forum.forum_id IS NOT NULL THEN
      response.status_code
    ELSE
      401
    END AS status_code
  FROM response
  LEFT JOIN update_forum
    ON TRUE
  LIMIT 1;
$update_forum$
  VOLATILE
  LANGUAGE sql;
