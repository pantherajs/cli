/**
 * @file bin/tasks/sql/misc/rollback-transaction.js
 */
'use strict';

const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Rolling back transaction...';

/**
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
const enabled = ctx => ctx.error === true;

/**
 * @param  {Object} ctx
 * @return {Promise}
 * @private
 */
const task = ctx => {
  return sqlTask(ctx, 'misc/rollback-transaction.sql')
    .then(() => ctx.inTransaction = false);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
