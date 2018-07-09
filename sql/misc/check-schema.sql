SELECT EXISTS(
  SELECT
    1
  FROM pg_namespace
  WHERE pg_namespace.nspname = %L
) AS "exists";
