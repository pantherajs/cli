/**
 * @file bin/tasks/sql/triggers/noncircular-parent-forum-reference.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `noncircular_parent_forum_reference` trigger...';

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = ctx => {
  return sqlTask(ctx, 'triggers/noncircular-parent-forum-reference.sql');
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
