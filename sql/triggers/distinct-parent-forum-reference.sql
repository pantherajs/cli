CREATE OR REPLACE FUNCTION distinct_parent_forum_reference()
RETURNS TRIGGER AS
$distinct_parent_forum_reference$
BEGIN
  IF (NEW.id = NEW.parent_forum_id) THEN
    RAISE EXCEPTION 'cannot nest forum under itself';
  END IF;

  RETURN NEW;
END;
$distinct_parent_forum_reference$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE plpgsql;

CREATE TRIGGER distinct_parent_forum_reference BEFORE INSERT ON forum
  FOR EACH ROW EXECUTE PROCEDURE distinct_parent_forum_reference();
