/**
 * @file bin/tasks/general/disconnect-from-database.js
 */
'use strict';

const pad = require('../../utils/pad');

/**
 * @type {String}
 */
const title = 'Disconnecting from PostgreSQL...';

/**
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
const enabled = ctx => ctx.connected === true;

/**
 * Creates a single PostgreSQL client and uses it to connect to the database
 * using the configuration stored in ctx.options.
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = (ctx, task) => {
  return ctx.client.end().then(() => {
    task.title = pad(task.title, 'done');
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
