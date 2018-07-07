WITH cte AS (
  SELECT
    TRUE          AS enabled,
    permission.id AS permission_id
  FROM role
  INNER JOIN permission
    ON role.id = permission.role_id
  WHERE role.name = 'Administrator'
)
UPDATE permission SET
  enabled = cte.enabled
FROM cte
WHERE permission.id = cte.permission_id;

WITH cte AS (
  SELECT
    TRUE          AS enabled,
    permission.id AS permission_id
  FROM role
  INNER JOIN permission
    ON role.id = permission.role_id
  WHERE role.name = 'Guest'
    AND permission.permission_type = 'CREATE'
    AND permission.resource_type = 'ACCOUNT'
)
UPDATE permission SET
  enabled = cte.enabled
  FROM cte
  WHERE permission.id = cte.permission_id;
