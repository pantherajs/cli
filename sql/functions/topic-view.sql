CREATE OR REPLACE FUNCTION topic_view(requested_id INTEGER, client_token UUID)
RETURNS TABLE (
  status_code    INTEGER,
  json_data      JSONB
) AS $topic_view$
  WITH RECURSIVE category_accessible AS (
    SELECT
      access_token.token,
      category_viewable.category_id,
      category_viewable.can_view
    FROM access_token
    INNER JOIN category_viewable
      ON access_token.account_id = category_viewable.account_id
      AND category_viewable.can_view = TRUE
    WHERE access_token.account_id IS NOT NULL
      AND access_token.token = client_token
      AND category_viewable.category_id = (
        SELECT
          forum.category_id
        FROM forum
        INNER JOIN topic
          ON forum.id = topic.forum_id
        WHERE topic.id = requested_id
      )
    UNION ALL
    SELECT
      access_token.token,
      category_permission.category_id,
      permission.enabled AS can_view
    FROM access_token
    INNER JOIN role
      ON role.name = 'Guest'
    INNER JOIN permission
      ON role.id = permission.role_id
      AND permission.enabled = TRUE
    INNER JOIN category_permission
      ON permission.id = category_permission.permission_id
    WHERE access_token.account_id IS NULL
      AND access_token.token = client_token
      AND category_permission.category_id = (
        SELECT
          forum.category_id
        FROM forum
        INNER JOIN topic
          ON forum.id = topic.forum_id
        WHERE topic.id = requested_id
      )
  ), forum_accessible AS (
    SELECT
      access_token.token,
      forum_viewable.forum_id,
      forum_viewable.can_view
    FROM access_token
    INNER JOIN forum_viewable
      ON access_token.account_id = forum_viewable.account_id
      AND forum_viewable.can_view = TRUE
    WHERE access_token.account_id IS NOT NULL
      AND access_token.token = client_token
    UNION ALL
    SELECT
      access_token.token,
      forum_permission.forum_id,
      permission.enabled AS can_view
    FROM access_token
    INNER JOIN role
      ON role.name = 'Guest'
    INNER JOIN permission
      ON role.id = permission.role_id
      AND permission.enabled = TRUE
    INNER JOIN forum_permission
      ON permission.id = forum_permission.permission_id
    WHERE access_token.account_id IS NULL
      AND access_token.token = client_token
  ), topic_agg AS (
    SELECT
      topic.id                   AS topic_id,
      topic.title                AS topic_title,
      topic.forum_id             AS topic_forum_id,
      topic_author.id            AS topic_author_id,
      topic_author.name          AS topic_author_name,
      topic.created              AS topic_created,
      topic_statistics.num_posts AS num_posts,
      jsonb_agg(jsonb_build_object(
        'post_id',          post.id,
        'post_content',     post.content,
        'post_created',     post.created,
        'post_author_id',   post_author.id,
        'post_author_name', post_author.name
      ) ORDER BY
        post.id ASC)             AS posts
    FROM topic
    INNER JOIN (
        SELECT
          forum_id,
          can_view
        FROM forum_accessible
      ) AS parent_forum
      ON topic.forum_id = parent_forum.forum_id
    INNER JOIN topic_statistics
      ON topic.id = topic_statistics.topic_id
    INNER JOIN post
      ON topic.id = post.topic_id
    INNER JOIN alias AS topic_author
      ON topic.author_alias_id = topic_author.id
    INNER JOIN alias AS post_author
      ON post.author_alias_id = post_author.id
    WHERE topic.id = requested_id
    GROUP BY
      topic.id,
      topic.title,
      topic.forum_id,
      topic_author.id,
      topic_author.name,
      topic.created,
      topic_statistics.num_posts
    LIMIT 1
  ), response (status_code) AS (
    VALUES (200)
  ), result AS (
    SELECT
      topic_agg.topic_id,
      jsonb_build_object(
        'topic_id',          topic_agg.topic_id,
        'topic_title',       topic_agg.topic_title,
        'topic_forum_id',    topic_agg.topic_forum_id,
        'topic_author_id',   topic_agg.topic_author_id,
        'topic_author_name', topic_agg.topic_author_name,
        'topic_created',     topic_agg.topic_created,
        'num_posts',         topic_agg.num_posts,
        'posts',             topic_agg.posts
      ) AS json_data
    FROM topic_agg
    LIMIT 1
  )
  SELECT
    CASE WHEN result.topic_id IS NOT NULL THEN
      response.status_code
    ELSE
      401
    END AS status_code,
    result.json_data
  FROM response
  LEFT JOIN result
    ON TRUE
  LIMIT 1;
$topic_view$
  STABLE
  LANGUAGE sql;
