CREATE OR REPLACE VIEW forum_viewable AS
  SELECT
    fresh.account_id,
    fresh.forum_id,
    fresh.can_view,
    fresh.expiry
  FROM forum_viewable_mat AS fresh
  WHERE CURRENT_TIMESTAMP < fresh.expiry
  UNION ALL
  SELECT
    stale.account_id,
    stale.forum_id,
    stale.can_view,
    stale.expiry
  FROM forum_viewable_mat
    CROSS JOIN refresh_forum_viewable_mat(
      forum_viewable_mat.account_id,
      forum_viewable_mat.forum_id
    ) AS stale
  WHERE forum_viewable_mat.expiry <= CURRENT_TIMESTAMP;

GRANT SELECT ON forum_viewable TO %I;
