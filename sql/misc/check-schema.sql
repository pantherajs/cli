SELECT EXISTS(
  SELECT 1 FROM pg_namespace WHERE nspname = %L
) AS "exists";
