CREATE OR REPLACE FUNCTION create_post(
  post_topic_id         INTEGER,
  post_author_alias_id  INTEGER,
  post_guest_alias_name CHARACTER VARYING,
  post_content          TEXT,
  client_token          UUID
) RETURNS TABLE (
  status_code INTEGER,
  json_data   JSONB
) AS $create_post$
  WITH existing_user_alias AS (
    SELECT
      alias.id      AS alias_id,
      alias.role_id AS role_id
    FROM alias
    INNER JOIN account
      ON alias.account_id = account.id
    INNER JOIN access_token
      ON account.id = access_token.account_id
      AND access_token.token = client_token
    WHERE alias.id = post_author_alias_id
      AND alias.type <> 'EXTERNAL'
      AND post_author_alias_id IS NOT NULL
      AND post_guest_alias_name IS NULL
    LIMIT 1
  ), existing_guest_alias AS (
    SELECT
      alias.id      AS alias_id,
      alias.role_id AS role_id
    FROM alias
    INNER JOIN access_token
      ON access_token.token = client_token
      AND access_token.account_id IS NULL
    WHERE alias.name = post_guest_alias_name
      AND alias.type = 'EXTERNAL'
      AND post_author_alias_id IS NULL
      AND post_guest_alias_name IS NOT NULL
    LIMIT 1
  ), inserted_guest_alias AS (
    INSERT INTO alias (role_id, name, type)
      SELECT
        role.id,
        post_guest_alias_name,
        'EXTERNAL'
      FROM role
      INNER JOIN access_token
        ON access_token.token = client_token
        AND access_token.account_id IS NULL
      WHERE role.name = 'Guest'
        AND post_author_alias_id IS NULL
        AND post_guest_alias_name IS NOT NULL
        AND (SELECT COUNT(*) FROM existing_guest_alias) = 0
      LIMIT 1
    RETURNING
      alias.id      AS alias_id,
      alias.role_id AS role_id
  ), acquire_alias AS (
    SELECT
      alias_id,
      role_id
    FROM existing_user_alias
    UNION ALL
    SELECT
      alias_id,
      role_id
    FROM existing_guest_alias
    UNION ALL
    SELECT
      alias_id,
      role_id
    FROM inserted_guest_alias
    LIMIT 1
  ), insert_post AS (
    INSERT INTO post (topic_id, author_alias_id, content)
      SELECT
        post_topic_id,
        acquire_alias.alias_id,
        post_content
      FROM acquire_alias
      INNER JOIN permission AS can_create_post
        ON acquire_alias.role_id = can_create_post.role_id
        AND can_create_post.permission_type = 'CREATE'
        AND can_create_post.resource_type = 'POST'
        AND can_create_post.enabled = TRUE
      INNER JOIN forum_permission AS can_create_post_in_forum
        ON can_create_post.id = can_create_post_in_forum.permission_id
        AND can_create_post_in_forum.forum_id = (
          SELECT
            topic.forum_id
          FROM topic
          WHERE topic.id = post_topic_id
        )
      LIMIT 1
    RETURNING
      post.id AS post_id,
      jsonb_build_object(
        'post_id', post.id
      )       AS json_data
  ), response (status_code) AS (
    VALUES (201)
  )
  SELECT
    CASE WHEN insert_post.post_id IS NOT NULL THEN
      response.status_code
    ELSE
      401
    END AS status_code,
    insert_post.json_data
  FROM response
  LEFT JOIN insert_post
    ON TRUE
  LIMIT 1;
$create_post$
  VOLATILE
  LANGUAGE sql;
