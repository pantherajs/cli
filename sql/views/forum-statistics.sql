CREATE OR REPLACE VIEW forum_statistics AS
  SELECT
    fresh.forum_id,
    fresh.num_topics,
    fresh.num_posts,
    fresh.recent_topic_id,
    fresh.recent_post_id,
    fresh.expiry
  FROM forum_statistics_mat AS fresh
  WHERE CURRENT_TIMESTAMP < fresh.expiry
  UNION ALL
  SELECT
    stale.forum_id,
    stale.num_topics,
    stale.num_posts,
    stale.recent_topic_id,
    stale.recent_post_id,
    stale.expiry
  FROM forum_statistics_mat
    CROSS JOIN refresh_forum_statistics_mat(forum_statistics_mat.forum_id) AS stale
  WHERE forum_statistics_mat.expiry <= CURRENT_TIMESTAMP;

GRANT SELECT ON forum_statistics TO %I;
