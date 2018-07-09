CREATE OR REPLACE FUNCTION enforce_noncircular_parent_forum_reference()
RETURNS TRIGGER AS
$enforce_noncircular_parent_forum_reference$
BEGIN
  IF (
    OLD.parent_forum_id IS DISTINCT FROM NEW.parent_forum_id
    AND NEW.parent_forum_id IS NOT NULL
    AND NEW.id IN (SELECT ancestor_forums(NEW.parent_forum_id))
  ) THEN
    RAISE EXCEPTION 'cannot have circular reference in nested forums';
  END IF;

  RETURN NEW;
END;
$enforce_noncircular_parent_forum_reference$
  LANGUAGE plpgsql;

CREATE TRIGGER enforce_noncircular_parent_forum_reference BEFORE UPDATE ON forum
  FOR EACH ROW EXECUTE PROCEDURE enforce_noncircular_parent_forum_reference();
