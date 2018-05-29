CREATE OR REPLACE VIEW category_view AS
  SELECT
    category.id       AS category_id,
    category.sort_key AS category_sort_key,
    json_build_object(
      'category_id',   category.id,
      'category_name', category.name,
      'forums', jsonb_agg(json_build_object(
        'forum_id',                 stats.forum_id,
        'forum_name',               stats.forum_name,
        'num_topics',               stats.num_topics,
        'num_posts',                stats.num_posts,
        'recent_topic_id',          stats.recent_topic_id,
        'recent_topic_title',       stats.recent_topic_title,
        'recent_topic_created',     stats.recent_topic_created,
        'recent_topic_author_id',   stats.recent_topic_author_id,
        'recent_topic_author_name', stats.recent_topic_author_name,
        'recent_post_id',           stats.recent_post_id,
        'recent_post_created',      stats.recent_post_created,
        'recent_post_author_id',    stats.recent_post_author_id,
        'recent_post_author_name',  stats.recent_post_author_name,
        'num_subforums',            stats.num_subforums,
        'subforums',                stats.subforums
      ) ORDER BY
        stats.forum_sort_key ASC,
        stats.forum_id ASC
      )
    )                 AS json_data
  FROM (
    SELECT
      forum.category_id                AS category_id,
      forum.id                         AS forum_id,
      forum.name                       AS forum_name,
      forum.sort_key                   AS forum_sort_key,
      forum_statistics.num_topics      AS num_topics,
      forum_statistics.num_posts       AS num_posts,
      forum_statistics.recent_topic_id AS recent_topic_id,
      topic.title                      AS recent_topic_title,
      topic.created                    AS recent_topic_created,
      topic_author.id                  AS recent_topic_author_id,
      topic_author.name                AS recent_topic_author_name,
      forum_statistics.recent_post_id  AS recent_post_id,
      post.created                     AS recent_post_created,
      post_author.id                   AS recent_post_author_id,
      post_author.name                 AS recent_post_author_name,
      COUNT(subforum.*)                AS num_subforums,
      jsonb_agg(json_build_object(
        'subforum_id',   subforum.id,
        'subforum_name', subforum.name
      ) ORDER BY
        subforum.sort_key ASC,
        subforum.id ASC
      )                                AS subforums
    FROM forum
    INNER JOIN forum AS subforum
      ON forum.id = subforum.parent_forum_id
    INNER JOIN forum_statistics
      ON forum.id = forum_statistics.forum_id
    INNER JOIN topic
      ON forum_statistics.recent_topic_id = topic.id
    INNER JOIN alias AS topic_author
      ON topic.author_alias_id = topic_author.id
    INNER JOIN post
      ON forum_statistics.recent_post_id = post.id
    INNER JOIN alias AS post_author
      ON post.author_alias_id = post_author.id
    WHERE forum.parent_forum_id IS NULL
    GROUP BY
      forum.category_id,
      forum.id,
      forum.name,
      forum.sort_key,
      forum_statistics.num_topics,
      forum_statistics.num_posts,
      forum_statistics.recent_topic_id,
      topic.title,
      topic.created,
      topic_author.id,
      topic_author.name,
      forum_statistics.recent_post_id,
      post.created,
      post_author.id,
      post_author.name
  ) AS stats
  INNER JOIN category
    ON stats.category_id = category.id
  GROUP BY
    category.id,
    category.name,
    category.sort_key;

GRANT SELECT ON category_view TO %I;
