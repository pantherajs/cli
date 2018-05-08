/**
 * @file bin/tasks/sql/misc/commit-transaction.js
 */
'use strict';

const pad     = require('../../../utils/pad');
const queryEnabled = require('../../../utils/query-enabled');
const since   = require('../../../utils/since');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Commiting transaction...';

/**
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
const enabled = ctx => queryEnabled(ctx) && ctx.error === false;

/**
 * @type {String}
 */
const file = 'misc/commit-transaction.sql';

/**
 * Commits a database transaction, setting the appropriate Boolean flag on the
 * task context object if successful.
 * @param  {Object} ctx
 * @return {Promise}
 * @private
 */
const task = ctx => sqlTask(ctx, file)
  .then(() => {
    const { start, title, task } = ctx.parent;

    task.title = pad(title, `${since(start)}ms`);
    ctx.inTransaction = false;
  });

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
