CREATE OR REPLACE FUNCTION insert_role()
RETURNS TRIGGER AS
$insert_role$
BEGIN
  INSERT INTO permission (role_id, permission_type, resource_type, enabled)
    SELECT
      NEW.id          AS role_id,
      permission.type AS permission_type,
      resource.type   AS resource_type,
      FALSE           AS enabled
    FROM (
      SELECT
        type
      FROM (
        SELECT
          unnest(enum_range(NULL::permission_type)) AS type
      ) AS types
      WHERE types.type IN ('CREATE', 'UPDATE', 'DELETE')
    ) AS permission
    CROSS JOIN (
      SELECT
        type
      FROM (
        SELECT
          unnest(enum_range(NULL::resource_type)) AS type
      ) AS types
      WHERE types.type IN ('ACCOUNT', 'ALIAS', 'CATEGORY', 'FORUM', 'PERMISSION', 'ROLE')
    ) AS resource
    UNION ALL
    SELECT
      NEW.id          AS role_id,
      permission.type AS permission_type,
      resource.type   AS resource_type,
      FALSE           AS enabled
    FROM (
      SELECT
        type
      FROM (
        SELECT
          unnest(enum_range(NULL::permission_type)) AS type
      ) AS types
      WHERE types.type NOT IN ('ACCESS', 'READ')
    ) AS permission
    CROSS JOIN (
      SELECT
        type
      FROM (
        SELECT
          unnest(enum_range(NULL::resource_type)) AS type
      ) AS types
      WHERE types.type IN ('TOPIC', 'POST')
    ) AS resource
    CROSS JOIN forum
    UNION ALL
    SELECT
      NEW.id     AS role_id,
      'READ'     AS permission_type,
      'CATEGORY' AS resource_type,
      FALSE      AS enabled
    FROM category
    UNION ALL
    SELECT
      NEW.id  AS role_id,
      'READ'  AS permission_type,
      'FORUM' AS resource_type,
      FALSE   AS enabled
    FROM forum
    UNION ALL
    SELECT
      NEW.id        AS role_id,
      'ACCESS'      AS permission_type,
      'ADMIN_PANEL' AS resource_type,
      FALSE         AS enabled;

  INSERT INTO category_permission (permission_id, category_id)
    SELECT
      permission.id,
      category.id
    FROM (
      SELECT
        permission.id,
        row_number() OVER () AS row_number
      FROM permission
      WHERE resource_type = 'CATEGORY'
        AND permission_type = 'READ'
        AND role_id = NEW.id
    ) AS permission
    INNER JOIN (
      SELECT
        category.id,
        row_number() OVER () AS row_number
      FROM category
    ) AS category
      ON permission.row_number = category.row_number;

  INSERT INTO forum_permission (permission_id, forum_id)
    SELECT
      permission.id AS permission_id,
      forum.id      AS forum_id
    FROM (
      SELECT
        permission.id,
        row_number() OVER () AS row_number
      FROM permission
      WHERE resource_type = 'FORUM'
        AND permission_type = 'READ'
        AND role_id = NEW.id
    ) AS permission
    INNER JOIN (
      SELECT
        forum.id,
        row_number() OVER () AS row_number
      FROM forum
    ) AS forum
      ON permission.row_number = forum.row_number
    UNION ALL
    SELECT
      permission.id AS permission_id,
      forum.id      AS forum_id
    FROM (
      SELECT
        permission.id,
        row_number() OVER () AS row_number
      FROM permission
      WHERE resource_type IN ('TOPIC', 'POST')
        AND permission_type IN ('CREATE', 'UPDATE', 'UPDATE_OWN', 'DELETE', 'DELETE_OWN')
        AND role_id = NEW.id
    ) AS permission
    INNER JOIN (
      SELECT
        forum.id,
        row_number() OVER () AS row_number
      FROM forum
    ) AS forum
      ON permission.row_number = forum.row_number;

  RETURN NEW;
END;
$insert_role$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER insert_role AFTER INSERT ON role
  FOR EACH ROW EXECUTE PROCEDURE insert_role();
