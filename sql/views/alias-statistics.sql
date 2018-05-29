CREATE OR REPLACE VIEW alias_statistics AS
  SELECT
    stale.alias_id,
    stale.num_topics,
    stale.num_posts,
    stale.recent_post_id,
    stale.expiry
  FROM alias_statistics_mat AS stale
  WHERE CURRENT_TIMESTAMP < stale.expiry
  UNION ALL
  SELECT
    fresh.alias_id,
    fresh.num_topics,
    fresh.num_posts,
    fresh.recent_post_id,
    fresh.expiry
  FROM alias_statistics_mat
    CROSS JOIN refresh_alias_statistics_mat(alias_statistics_mat.alias_id) AS fresh
  WHERE alias_statistics_mat.expiry <= CURRENT_TIMESTAMP;

GRANT SELECT ON alias_statistics TO %I;
