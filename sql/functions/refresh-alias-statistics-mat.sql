CREATE OR REPLACE FUNCTION refresh_alias_statistics_mat(target_id INTEGER)
RETURNS alias_statistics_mat AS
$refresh_alias_statistics_mat$
  WITH cte AS (
    SELECT
      COALESCE(
        COUNT(DISTINCT topic.*) FILTER (WHERE topic.created <= CURRENT_TIMESTAMP),
        0
      ) AS num_topics,
      COALESCE(
        COUNT(DISTINCT post.*) FILTER (WHERE post.created <= CURRENT_TIMESTAMP),
        0
      ) AS num_posts,
      MAX(post.id) AS recent_post_id,
      COALESCE(
        MIN(post.created) FILTER (WHERE CURRENT_TIMESTAMP < post.created),
        'infinity'::TIMESTAMPTZ
      ) AS expiry
    FROM alias
    LEFT JOIN topic
      ON alias.id = topic.author_alias_id
    LEFT JOIN post
      ON alias.id = post.author_alias_id
    WHERE alias.id = target_id
  )
  UPDATE alias_statistics_mat SET
    num_topics     = cte.num_topics,
    num_posts      = cte.num_posts,
    recent_post_id = cte.recent_post_id,
    expiry         = cte.expiry
  FROM cte
  WHERE alias_id = target_id
  RETURNING alias_statistics_mat.*;
$refresh_alias_statistics_mat$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE sql;
