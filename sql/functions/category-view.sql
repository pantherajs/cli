CREATE OR REPLACE FUNCTION category_view(target_id INTEGER, target_token UUID)
RETURNS TABLE (
  status_code       INTEGER,
  category_id       INTEGER,
  category_sort_key INTEGER,
  json_data         JSONB
) AS $category_view$
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
      AND access_token.token = target_token
      AND category_viewable.category_id = target_id
    UNION ALL
    SELECT
      access_token.token,
      category_permission.category_id,
      permission.state AS can_view
    FROM access_token
    INNER JOIN role
      ON role.name = 'Guest'
    INNER JOIN permission
      ON role.id = permission.role_id
      AND permission.state = TRUE
    INNER JOIN category_permission
      ON permission.id = category_permission.permission_id
    WHERE access_token.account_id IS NULL
      AND access_token.token = target_token
      AND category_permission.category_id = target_id
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
      AND access_token.token = target_token
    UNION ALL
    SELECT
      access_token.token,
      forum_permission.forum_id,
      permission.state AS can_view
    FROM access_token
    INNER JOIN role
      ON role.name = 'Guest'
    INNER JOIN permission
      ON role.id = permission.role_id
      AND permission.state = TRUE
    INNER JOIN forum_permission
      ON permission.id = forum_permission.permission_id
    WHERE access_token.account_id IS NULL
    AND access_token.token = target_token
  ), descendant AS (
    SELECT
      forum.id       AS forum_id,
      forum.sort_key AS forum_sort_key,
      forum.name     AS forum_name,
      forum.parent_forum_id,
      forum_accessible.token,
      forum_accessible.can_view
    FROM forum
    INNER JOIN category_accessible
      ON forum.category_id = category_accessible.category_id
    INNER JOIN forum_accessible
      ON forum.id = forum_accessible.forum_id
    WHERE forum.category_id = target_id
      AND forum.parent_forum_id IS NULL
      AND forum_accessible.token = target_token
    UNION ALL
    SELECT
      child.id       AS forum_id,
      child.sort_key AS forum_sort_key,
      child.name     AS forum_name,
      child.parent_forum_id,
      forum_accessible.token,
      forum_accessible.can_view
    FROM forum AS child
    INNER JOIN forum_accessible
      ON child.id = forum_accessible.forum_id
      AND forum_accessible.can_view = TRUE
    INNER JOIN descendant
      ON child.category_id = target_id
      AND child.parent_forum_id = descendant.forum_id
      AND forum_accessible.token = descendant.token
  ), forum_agg AS (
    SELECT
      forum.id                             AS forum_id,
      forum.sort_key                       AS forum_sort_key,
      forum.category_id                    AS forum_category_id,
      forum.name                           AS forum_name,
      SUM(forum_statistics.num_topics) FILTER (
        WHERE descendants.forum_id IS NOT NULL
          AND forum.id IN (descendants.forum_id, descendants.parent_forum_id)
          AND descendants.can_view = TRUE
      )                                    AS num_topics,
      SUM(forum_statistics.num_posts) FILTER (
        WHERE descendants.forum_id IS NOT NULL
          AND forum.id IN (descendants.forum_id, descendants.parent_forum_id)
          AND descendants.can_view = TRUE
      )                                    AS num_posts,
      MAX(forum_statistics.recent_post_id) FILTER (
        WHERE descendants.forum_id IS NOT NULL
          AND forum.id IN (descendants.forum_id, descendants.parent_forum_id)
          AND descendants.can_view = TRUE
      )                                    AS recent_post_id,
      COUNT(descendants.*) FILTER (
        WHERE descendants.forum_id IS NOT NULL
          AND descendants.parent_forum_id = forum.id
      )                                    AS num_subforums,
      COALESCE(jsonb_agg(jsonb_build_object(
        'subforum_id',   descendants.forum_id,
        'subforum_name', descendants.forum_name
      ) ORDER BY
          descendants.forum_sort_key ASC,
          descendants.forum_id ASC)
        FILTER (
          WHERE descendants.forum_id IS NOT NULL
            AND descendants.parent_forum_id = forum.id
            AND descendants.can_view = TRUE
        ),
      '[]'::jsonb)                         AS subforums
    FROM forum
    LEFT JOIN (
        SELECT
          forum_id,
          forum_name,
          forum_sort_key,
          parent_forum_id,
          can_view
        FROM descendant
      ) AS descendants
      ON forum.id IN (descendants.forum_id, descendants.parent_forum_id)
    INNER JOIN forum_statistics
      ON descendants.forum_id = forum_statistics.forum_id
    WHERE forum.category_id = target_id
      AND forum.parent_forum_id IS NULL
    GROUP BY
      forum.id,
      forum.sort_key,
      forum.category_id,
      forum.name
  ), forum_result AS (
    SELECT
      forum_agg.forum_id,
      forum_agg.forum_sort_key,
      forum_agg.forum_category_id,
      jsonb_build_object(
        'forum_id',                 forum_agg.forum_id,
        'forum_name',               forum_agg.forum_name,
        'num_topics',               forum_agg.num_topics,
        'num_posts',                forum_agg.num_posts,
        'recent_topic_id',          topic.id,
        'recent_topic_title',       topic.title,
        'recent_topic_created',     topic.created,
        'recent_topic_author_id',   topic_author.id,
        'recent_topic_author_name', topic_author.name,
        'recent_post_id',           post.id,
        'recent_post_created',      post.created,
        'recent_post_author_id',    post_author.id,
        'recent_post_author_name',  post_author.name,
        'num_subforums',            forum_agg.num_subforums,
        'subforums',                forum_agg.subforums
      ) AS json_data
    FROM forum_agg
    LEFT JOIN post
      ON forum_agg.recent_post_id = post.id
    LEFT JOIN alias AS post_author
      ON post.author_alias_id = post_author.id
    LEFT JOIN topic
      ON post.topic_id = topic.id
    LEFT JOIN alias AS topic_author
      ON topic.author_alias_id = topic_author.id
  ), result AS (
    SELECT
      category.id       AS category_id,
      category.sort_key AS category_sort_key,
      jsonb_build_object(
        'category_id',   category.id,
        'category_name', category.name,
        'num_forums',    COUNT(forum_result.*),
        'forums',        COALESCE(
          jsonb_agg(forum_result.json_data
          ORDER BY
            forum_result.forum_sort_key ASC,
            forum_result.forum_id ASC),
          '[]'::JSONB
        )
      )                 AS json_data
    FROM category
    INNER JOIN category_accessible
      ON category.id = category_accessible.category_id
    LEFT JOIN forum_result
      ON category.id = forum_result.forum_category_id
    WHERE category.id = target_id
    GROUP BY
      category.id,
      category.sort_key,
      category.name
    LIMIT 1
  ), response (status_code) AS (
    VALUES (200)
  )
  SELECT
    CASE WHEN result.category_id IS NOT NULL THEN
      response.status_code
    ELSE
      401
    END AS status_code,
    result.*
  FROM response
  LEFT JOIN result
    ON TRUE
  LIMIT 1;
$category_view$
  STABLE
  LANGUAGE sql;
