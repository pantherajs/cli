CREATE OR REPLACE FUNCTION refresh_forum_viewable_mat(
  target_account_id INTEGER,
  target_forum_id INTEGER
)
RETURNS forum_viewable_mat AS
$refresh_forum_viewable_mat$
  WITH cte AS (
    SELECT
      permission_forum.forum_id                  AS forum_id,
      COALESCE(BOOL_OR(permission.state), FALSE) AS can_view
    FROM permission_forum
    INNER JOIN permission
      ON permission_forum.permission_id = permission.id
    INNER JOIN role
      ON permission.role_id = role.id
    INNER JOIN alias
      ON role.id = alias.role_id
    WHERE alias.account_id = target_account_id
      AND permission_forum.forum_id = target_forum_id
    GROUP BY
      permission_forum.forum_id
  )
  UPDATE forum_viewable_mat SET
    can_view = cte.can_view,
    expiry   = 'infinity'::TIMESTAMPTZ
  FROM cte
  WHERE forum_viewable_mat.account_id = target_account_id
    AND forum_viewable_mat.forum_id = target_forum_id
  RETURNING forum_viewable_mat.*;
$refresh_forum_viewable_mat$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE sql;
