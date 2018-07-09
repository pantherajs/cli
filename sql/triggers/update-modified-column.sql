CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $update_modified_column$
BEGIN
  NEW.modified = now();
  RETURN NEW;
END;
$update_modified_column$
  LANGUAGE plpgsql;
