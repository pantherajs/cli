/**
 * @file bin/tasks/sql/triggers/update-role.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `update_role` trigger...';

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = ctx => {
  return sqlTask(ctx, 'triggers/update-role.sql');
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
