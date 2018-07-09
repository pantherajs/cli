CREATE OR REPLACE FUNCTION enforce_distinct_parent_forum_reference()
RETURNS TRIGGER AS
$enforce_distinct_parent_forum_reference$
BEGIN
  IF (NEW.id = NEW.parent_forum_id) THEN
    RAISE EXCEPTION 'cannot nest forum under itself';
  END IF;

  RETURN NEW;
END;
$enforce_distinct_parent_forum_reference$
  LANGUAGE plpgsql;

CREATE TRIGGER enforce_distinct_parent_forum_reference BEFORE INSERT ON forum
  FOR EACH ROW EXECUTE PROCEDURE enforce_distinct_parent_forum_reference();
