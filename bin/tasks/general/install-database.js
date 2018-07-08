/**
 * @file bin/tasks/general/install-database.js
 */
'use strict';

const Listr      = require('listr');
const path       = require('path');
const requireAll = require('require-all');

const sql = requireAll(path.join(__dirname, '../sql'));

/* eslint dot-notation: "off" */

/**
 * @type {Array.<Object>}
 */
const tasks = [
  sql.misc['begin-transaction'],
  sql.misc['drop-schema'],
  sql.misc['create-schema'],
  sql.misc['create-api-user'],
  sql.misc['grant-user-permissions'],
  sql.misc['set-search-path'],
  sql.functions['uuid'],
  sql.types['alias-type'],
  sql.types['permission-type'],
  sql.types['resource-type'],
  sql.triggers['update-modified-column'],
  sql.tables['account'],
  sql.tables['access-token'],
  sql.tables['role'],
  sql.tables['alias'],
  sql.tables['permission'],
  sql.tables['category'],
  sql.tables['category-permission'],
  sql.tables['category-viewable-mat'],
  sql.tables['forum'],
  sql.functions['ancestor-forums'],
  sql.functions['descendant-forums'],
  sql.tables['forum-permission'],
  sql.tables['forum-viewable-mat'],
  sql.tables['topic'],
  sql.tables['post'],
  sql.tables['alias-statistics-mat'],
  sql.tables['topic-statistics-mat'],
  sql.tables['forum-statistics-mat'],
  sql.triggers['insert-account'],
  sql.triggers['insert-alias'],
  sql.triggers['update-alias'],
  sql.triggers['delete-alias'],
  sql.triggers['insert-role'],
  sql.triggers['update-role'],
  sql.triggers['delete-role'],
  sql.triggers['update-permission'],
  sql.triggers['insert-category'],
  sql.triggers['distinct-parent-forum-reference'],
  sql.triggers['noncircular-parent-forum-reference'],
  sql.triggers['insert-forum'],
  sql.triggers['insert-topic'],
  sql.triggers['update-topic'],
  sql.triggers['delete-topic'],
  sql.triggers['insert-post'],
  sql.triggers['update-post'],
  sql.triggers['delete-post'],
  sql.functions['refresh-category-viewable-mat'],
  sql.views['category-viewable'],
  sql.functions['refresh-forum-viewable-mat'],
  sql.views['forum-viewable'],
  sql.functions['refresh-alias-statistics-mat'],
  sql.views['alias-statistics'],
  sql.functions['refresh-topic-statistics-mat'],
  sql.views['topic-statistics'],
  sql.functions['refresh-forum-statistics-mat'],
  sql.views['forum-statistics'],
  sql.functions['topic-view'],
  sql.functions['forum-view'],
  sql.functions['category-view'],
  sql.functions['index-view'],
  sql.functions['create-forum'],
  sql.functions['update-forum'],
  sql.functions['delete-forum'],
  sql.functions['create-category'],
  sql.functions['update-category'],
  sql.functions['delete-category'],
  sql.seed['roles'],
  sql.seed['permissions'],
  sql.misc['commit-transaction'],
  sql.misc['rollback-transaction']
];

/**
 * @type {String}
 */
const title = 'Installing database...';

/**
 * @param  {Object} ctx
 * @return {Boolan}
 * @private
 */
const enabled = ctx => ctx.connected === true;

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Listr}
 * @private
 */
const task = (ctx, task) => {
  const schema = ctx.env.PANTHERA_SCHEMA;

  ctx.parent = {
    start: process.hrtime(),
    title: `Installing database into \`${schema}\`...`,
    task
  };

  task.title = ctx.parent.title;

  return new Listr(tasks);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
