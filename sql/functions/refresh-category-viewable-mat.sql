CREATE OR REPLACE FUNCTION refresh_category_viewable_mat(
  target_account_id INTEGER,
  target_category_id INTEGER
)
RETURNS category_viewable_mat AS
$refresh_category_viewable_mat$
  WITH cte AS (
    SELECT
      category_permission.category_id                        AS category_id,
      COALESCE(BOOL_OR(category_permission.can_view), FALSE) AS can_view
    FROM category_permission
    INNER JOIN role
      ON category_permission.role_id = role.id
    INNER JOIN alias
      ON role.id = alias.role_id
    WHERE alias.account_id = target_account_id
      AND category_permission.category_id = target_category_id
    GROUP BY
      category_permission.category_id
  )
  UPDATE category_viewable_mat SET
    can_view = cte.can_view,
    expiry   = 'infinity'::TIMESTAMPTZ
  FROM cte
  WHERE category_viewable_mat.account_id = target_account_id
    AND category_viewable_mat.category_id = target_category_id
  RETURNING category_viewable_mat.*;
$refresh_category_viewable_mat$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE sql;
