SELECT EXISTS(
  SELECT 1 FROM pg_roles WHERE rolname = %L
) AS "exists";
