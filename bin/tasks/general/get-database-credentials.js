/**
 * @file bin/tasks/general/get-database-credentials.js
 */
'use strict';

const Listr = require('listr');

const getUser     = require('../prompts/get-database-user');
const getPassword = require('../prompts/get-database-password');
const getDatabase = require('../prompts/get-database-name');
const getHost     = require('../prompts/get-database-host');
const getPort     = require('../prompts/get-database-port');

/**
 * @type {String}
 */
const title = 'Prompting for database credentials...';

/**
 * This task is only intended to be run if the user doesn't have credentials
 * saved in environment variables. See bin/tasks/general/check-environment.js
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
const enabled = ctx => ctx.dbEnv === false;

/**
 * Prompts for database connection credentials.
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Listr}
 * @private
 */
const task = (ctx, task) => {
  ctx.parent = { title: task.title, task };

  return new Listr([
    getUser,
    getPassword,
    getDatabase,
    getHost,
    getPort
  ]);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
