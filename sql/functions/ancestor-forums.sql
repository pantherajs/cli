CREATE OR REPLACE FUNCTION ancestor_forums(root_id INTEGER)
RETURNS TABLE (
  id INTEGER
) AS $ancestor_forums$
  WITH RECURSIVE ancestors AS (
    SELECT
      id,
      parent_forum_id
    FROM forum
    WHERE id = root_id
    UNION ALL
    SELECT
      parent.id,
      parent.parent_forum_id
    FROM forum AS parent
    INNER JOIN ancestors
      ON parent.id = ancestors.parent_forum_id
  )
  SELECT
    id
  FROM ancestors;
$ancestor_forums$
  VOLATILE
  SECURITY DEFINER
  LANGUAGE sql;
