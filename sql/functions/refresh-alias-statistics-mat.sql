CREATE OR REPLACE FUNCTION refresh_alias_statistics_mat(target_id INTEGER)
RETURNS alias_statistics_mat AS
$refresh_alias_statistics_mat$
  WITH topic AS (
    SELECT
      COALESCE(
        COUNT(topic.*) FILTER (WHERE topic.created <= CURRENT_TIMESTAMP),
        0
      ) AS num_topics
    FROM topic
    WHERE topic.author_alias_id = target_id
  ), post AS (
    SELECT
      COALESCE(
        COUNT(post.*) FILTER (WHERE post.created <= CURRENT_TIMESTAMP),
        0
      )            AS num_posts,
      MAX(post.id) AS recent_post_id,
      COALESCE(
        MIN(post.created) FILTER (WHERE CURRENT_TIMESTAMP < post.created),
        'infinity'::TIMESTAMPTZ
      )            AS expiry
    FROM post
    WHERE post.author_alias_id = target_id
  )
  UPDATE alias_statistics_mat SET
    num_topics     = topic.num_topics,
    num_posts      = post.num_posts,
    recent_post_id = post.recent_post_id,
    expiry         = post.expiry
  FROM topic
  CROSS JOIN post
  WHERE alias_statistics_mat.alias_id = target_id
  RETURNING alias_statistics_mat.*;
$refresh_alias_statistics_mat$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE sql;
