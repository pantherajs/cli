/**
 * @file bin/tasks/sql/misc/begin-transaction.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Beginning transaction...';

/**
 * @type {String}
 */
const file = 'misc/begin-transaction.sql';

/**
 * Begins a database transaction, setting the appropriate Boolean flag on the
 * task context object if successful.
 * @param  {Object} ctx
 * @return {Promise}
 * @private
 */
const task = ctx => sqlTask(ctx, file)
  .then(() => ctx.inTransaction = true);

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
