CREATE OR REPLACE VIEW index_view AS
  SELECT
    COALESCE(
      jsonb_agg(
        category_view.json_data
        ORDER BY
          category_view.category_sort_key ASC,
          category_view.category_id ASC
      ),
      '[]'::JSONB
    ) AS json_data
  FROM category_view;

GRANT SELECT ON index_view TO %I;
