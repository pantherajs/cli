CREATE OR REPLACE FUNCTION uuid()
RETURNS UUID AS $uuid$
BEGIN
  RETURN overlay(
    overlay(
      md5(random()::TEXT || ':' || clock_timestamp()::TEXT)
      placing '4' FROM 13
    )
    placing floor(random()*(11-8+1) + 8)::TEXT FROM 17
  )::UUID;
END;
$uuid$
  IMMUTABLE
  LANGUAGE plpgsql;
