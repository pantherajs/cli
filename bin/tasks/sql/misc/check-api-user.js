/**
 * @file bin/tasks/sql/misc/check-api-user.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const pad     = require('../../../utils/pad');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Checking API user...';

/**
 * @type {String}
 */
const file = 'misc/check-api-user.sql';

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = (ctx, task) => {
  const user = ctx.env.PANTHERA_API_USER;

  task.title = `Checking API user \`${user}\`...`;

  return sqlTask(ctx, file, user).then(result => {
    ctx.apiUserExists = result.rows[0].exists;
    task.title = pad(task.title, (ctx.apiUserExists) ? 'found' : 'not found');
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
