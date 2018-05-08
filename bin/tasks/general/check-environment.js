/**
 * @file bin/tasks/general/check-environment.js
 */
'use strict';

const has = require('../../utils/has');
const pad = require('../../utils/pad');

/**
 * The environment variables used to connect to the database outside the
 * application. If not found, users will be prompted for this information.
 * @type {Array.<String>}
 */
const database = [
  'PANTHERA_DB_USER',
  'PANTHERA_DB_PASS',
  'PANTHERA_DB_NAME',
  'PANTHERA_DB_HOST',
  'PANTHERA_DB_PORT'
];

/**
 * The environment variables used to configure database installation and access
 * from within the application. If not found, users will be prompted for this
 * information.
 * @type {Array.<String>}
 */
const config = [
  'PANTHERA_SCHEMA',
  'PANTHERA_API_USER',
  'PANTHERA_API_PASS'
];

/**
 * @type {String}
 */
const title = 'Checking environment variables...';

/**
 * Checks for environment variables and sets appropriate Boolean flags on the
 * context object if found.
 * @param {Object} ctx
 * @param {Object} task
 * @private
 */
const task = (ctx, task) => {
  ctx.dbEnv  = has(ctx.env, ...database);
  ctx.apiEnv = has(ctx.env, ...config);
  task.title = pad(title, 'done');
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, task };
