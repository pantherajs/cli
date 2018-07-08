CREATE OR REPLACE FUNCTION refresh_forum_statistics_mat(requested_id INTEGER)
RETURNS forum_statistics_mat AS
$refresh_forum_statistics_mat$
  WITH cte AS (
    SELECT
      COALESCE(
        COUNT(*) FILTER (WHERE topic.created <= CURRENT_TIMESTAMP),
        0
      ) AS num_topics,
      COALESCE(
        SUM(topic_statistics.num_posts),
        0
      ) AS num_posts,
      MAX(topic_statistics.recent_post_id) AS recent_post_id,
      COALESCE(
        MIN(topic.created) FILTER (WHERE CURRENT_TIMESTAMP < topic.created),
        'infinity'::TIMESTAMPTZ
      ) AS expiry
    FROM forum
    LEFT JOIN topic
      ON topic.forum_id = forum.id
    INNER JOIN topic_statistics
      ON topic_statistics.topic_id = topic.id
    WHERE forum.id = requested_id
  )
  UPDATE forum_statistics_mat SET
    num_topics      = cte.num_topics,
    num_posts       = cte.num_posts,
    recent_topic_id = topic.id,
    recent_post_id  = cte.recent_post_id,
    expiry          = cte.expiry
  FROM cte
  LEFT JOIN post
    ON cte.recent_post_id = post.id
  LEFT JOIN topic
    ON post.topic_id = topic.id
  WHERE forum_statistics_mat.forum_id = requested_id
  RETURNING forum_statistics_mat.*;
$refresh_forum_statistics_mat$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE sql;
