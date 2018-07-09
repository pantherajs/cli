CREATE OR REPLACE FUNCTION create_forum(
  forum_category_id     INTEGER,
  forum_parent_forum_id INTEGER,
  forum_name            VARCHAR,
  forum_sort_key        INTEGER,
  client_token          UUID
) RETURNS TABLE (
  status_code INTEGER,
  json_data   JSONB
) AS $create_forum$
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
    INNER JOIN permission AS can_create_forum
      ON alias.role_id = can_create_forum.role_id
      AND can_create_forum.permission_type = 'CREATE'
      AND can_create_forum.resource_type = 'FORUM'
      AND can_create_forum.enabled = TRUE
    WHERE access_token.token = client_token
    LIMIT 1
  ), insert_forum AS (
    INSERT INTO forum (category_id, parent_forum_id, name, sort_key)
      SELECT
        forum_category_id,
        forum_parent_forum_id,
        forum_name,
        COALESCE(forum_sort_key, 0)
      FROM authorized_user
    RETURNING
      forum.id AS forum_id,
      jsonb_build_object(
        'forum_id', forum.id
      )        AS json_data
  ), response (status_code) AS (
    VALUES (201)
  )
  SELECT
    CASE WHEN insert_forum.forum_id IS NOT NULL THEN
      response.status_code
    ELSE
      401
    END AS status_code,
    insert_forum.json_data
  FROM response
  LEFT JOIN insert_forum
    ON TRUE
  LIMIT 1;
$create_forum$
  VOLATILE
  LANGUAGE sql;
