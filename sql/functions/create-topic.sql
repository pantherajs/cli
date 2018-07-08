CREATE OR REPLACE FUNCTION create_topic(
  topic_forum_id         INTEGER,
  topic_author_alias_id  INTEGER,
  topic_guest_alias_name CHARACTER VARYING,
  topic_title            CHARACTER VARYING,
  topic_post_contents    TEXT,
  client_token           UUID
) RETURNS TABLE (
  status_code INTEGER,
  json_data   JSONB
) AS $create_topic$
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
    WHERE alias.id = topic_author_alias_id
      AND alias.type <> 'EXTERNAL'
      AND topic_author_alias_id IS NOT NULL
      AND topic_guest_alias_name IS NULL
    LIMIT 1
  ), existing_guest_alias AS (
    SELECT
      alias.id      AS alias_id,
      alias.role_id AS role_id
    FROM alias
    INNER JOIN access_token
      ON access_token.token = client_token
      AND access_token.account_id IS NULL
    WHERE alias.name = topic_guest_alias_name
      AND alias.type = 'EXTERNAL'
      AND topic_author_alias_id IS NULL
      AND topic_guest_alias_name IS NOT NULL
    LIMIT 1
  ), inserted_guest_alias AS (
    INSERT INTO alias (role_id, name, type)
      SELECT
        role.id,
        topic_guest_alias_name,
        'EXTERNAL'
      FROM role
      INNER JOIN access_token
        ON access_token.token = client_token
        AND access_token.account_id IS NULL
      WHERE role.name = 'Guest'
        AND topic_author_alias_id IS NULL
        AND topic_guest_alias_name IS NOT NULL
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
  ), insert_topic AS (
    INSERT INTO topic (forum_id, author_alias_id, title)
      SELECT
        topic_forum_id,
        acquire_alias.alias_id,
        topic_title
      FROM acquire_alias
      INNER JOIN permission AS can_create_topic
        ON acquire_alias.role_id = can_create_topic.role_id
        AND can_create_topic.permission_type = 'CREATE'
        AND can_create_topic.resource_type = 'TOPIC'
        AND can_create_topic.enabled = TRUE
      INNER JOIN forum_permission AS can_create_topic_in_forum
        ON can_create_topic.id = can_create_topic_in_forum.permission_id
        AND can_create_topic_in_forum.forum_id = topic_forum_id
      INNER JOIN permission AS can_create_post
        ON acquire_alias.role_id = can_create_post.role_id
        AND can_create_post.permission_type = 'CREATE'
        AND can_create_post.resource_type = 'POST'
        AND can_create_post.enabled = TRUE
      INNER JOIN forum_permission AS can_create_post_in_forum
        ON can_create_post.id = can_create_post_in_forum.permission_id
        AND can_create_post_in_forum.forum_id = topic_forum_id
      LIMIT 1
    RETURNING
      topic.id              AS topic_id,
      topic.author_alias_id AS author_alias_id
  ), insert_first_post AS (
    INSERT INTO post (topic_id, author_alias_id, content)
      SELECT
        insert_topic.topic_id,
        insert_topic.author_alias_id,
        topic_post_contents
      FROM insert_topic
      LIMIT 1
    RETURNING
      post.topic_id AS topic_id,
      jsonb_build_object(
        'topic_id', post.topic_id
      ) AS json_data
  ), response (status_code) AS (
    VALUES (201)
  )
  SELECT
    CASE WHEN insert_first_post.topic_id IS NOT NULL THEN
      response.status_code
    ELSE
      401
    END AS status_code,
    insert_first_post.json_data
  FROM response
  LEFT JOIN insert_first_post
    ON TRUE
  LIMIT 1;
$create_topic$
  VOLATILE
  LANGUAGE sql;
