CREATE OR REPLACE VIEW topic_statistics AS
  SELECT
    stale.topic_id,
    stale.recent_post_id,
    stale.num_posts,
    stale.expiry
  FROM topic_statistics_mat AS stale
  WHERE CURRENT_TIMESTAMP < stale.expiry
  UNION ALL
  SELECT
    fresh.topic_id,
    fresh.recent_post_id,
    fresh.num_posts,
    fresh.expiry
  FROM topic_statistics_mat
    CROSS JOIN refresh_topic_statistics_mat(topic_statistics_mat.topic_id) AS fresh
  WHERE topic_statistics_mat.expiry <= CURRENT_TIMESTAMP;

GRANT SELECT ON topic_statistics TO %I;
