SELECT EXISTS(
  SELECT
    1
  FROM pg_roles
  WHERE pg_roles.rolname = %L
) AS "exists";
