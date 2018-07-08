CREATE OR REPLACE FUNCTION descendant_forums(root_id INTEGER)
RETURNS TABLE (
  id INTEGER
) AS $descendant_forums$
  WITH RECURSIVE descendants AS (
    SELECT
      id,
      parent_forum_id
    FROM forum
    WHERE id = root_id
    UNION ALL
    SELECT
      subforum.id,
      subforum.parent_forum_id
    FROM forum AS subforum
    INNER JOIN descendants
      ON subforum.parent_forum_id = descendants.id
  )
  SELECT
    id
  FROM descendants;
$descendant_forums$
  STABLE
  LANGUAGE sql;
