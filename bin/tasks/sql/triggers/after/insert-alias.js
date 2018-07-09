/**
 * @file bin/tasks/sql/triggers/after/insert-alias.js
 */
'use strict';

const enabled = require('../../../../utils/query-enabled');
const sqlTask = require('../../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `insert_alias` trigger...';

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = ctx => {
  return sqlTask(ctx, 'triggers/after/insert-alias.sql');
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
