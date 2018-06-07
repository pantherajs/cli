CREATE OR REPLACE VIEW category_view AS
  SELECT
    category.id       AS category_id,
    category.sort_key AS category_sort_key,
    json_build_object(
      'category_id',   category.id,
      'category_name', category.name,
      'forums',        COALESCE(jsonb_agg(
          forum_view.json_data
          ORDER BY
            forum.sort_key ASC,
            forum.id ASC
        ), '[]'::jsonb)
    )                 AS json_data
  FROM category
  INNER JOIN forum
    ON category.id = forum.category_id
  INNER JOIN forum_view
    ON forum.id = forum_view.forum_id
  WHERE forum.parent_forum_id IS NULL
  GROUP BY
    category.id,
    category.name,
    category.sort_key;

GRANT SELECT ON category_view TO %I;
