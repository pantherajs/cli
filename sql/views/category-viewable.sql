CREATE OR REPLACE VIEW category_viewable AS
  SELECT
    fresh.account_id,
    fresh.category_id,
    fresh.can_view,
    fresh.expiry
  FROM category_viewable_mat AS fresh
  WHERE CURRENT_TIMESTAMP < fresh.expiry
  UNION ALL
  SELECT
    stale.account_id,
    stale.category_id,
    stale.can_view,
    stale.expiry
  FROM category_viewable_mat
    CROSS JOIN refresh_category_viewable_mat(category_viewable_mat.account_id) AS stale
  WHERE category_viewable_mat.expiry <= CURRENT_TIMESTAMP;

GRANT SELECT ON category_viewable TO %I;
