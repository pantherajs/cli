CREATE OR REPLACE FUNCTION refresh_topic_statistics_mat(requested_id INTEGER)
RETURNS topic_statistics_mat AS
$refresh_topic_statistics_mat$
  WITH cte AS (
    SELECT
      COALESCE(
        COUNT(*) FILTER (WHERE post.created <= CURRENT_TIMESTAMP),
        0
      ) AS num_posts,
      MAX(post.id) AS recent_post_id,
      COALESCE(
        MIN(post.created) FILTER (WHERE CURRENT_TIMESTAMP < post.created),
        'infinity'::TIMESTAMPTZ
      ) AS expiry
    FROM topic
    LEFT JOIN post
      ON topic.id = post.topic_id
    WHERE topic_id = requested_id
  )
  UPDATE topic_statistics_mat SET
    num_posts      = cte.num_posts,
    recent_post_id = cte.recent_post_id,
    expiry         = cte.expiry
  FROM cte
  WHERE topic_statistics_mat.topic_id = requested_id
  RETURNING
    topic_statistics_mat.*;
$refresh_topic_statistics_mat$
  VOLATILE
  LANGUAGE sql;
