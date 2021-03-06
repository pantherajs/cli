CREATE OR REPLACE FUNCTION ancestor_forums(
  root_id INTEGER
) RETURNS TABLE (
  id INTEGER
) AS $ancestor_forums$
  WITH RECURSIVE ancestors AS (
    SELECT
      forum.id,
      forum.parent_forum_id
    FROM forum
    WHERE forum.id = root_id
    UNION ALL
    SELECT
      parent.id,
      parent.parent_forum_id
    FROM forum AS parent
    INNER JOIN ancestors
      ON parent.id = ancestors.parent_forum_id
  )
  SELECT
    ancestors.id
  FROM ancestors;
$ancestor_forums$
  STABLE
  LANGUAGE sql;
