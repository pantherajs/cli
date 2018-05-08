/**
 * @file bin/tasks/general/get-configuration.js
 */
'use strict';

const Listr = require('listr');

const getSchema   = require('../prompts/get-schema');
const getUser     = require('../prompts/get-api-user');
const getPassword = require('../prompts/get-api-password');

/**
 * @type {String}
 */
const title = 'Prompting for database configuration...';

/**
 * This task is only intended to be run if the user doesn't have API config
 * saved in environment variables. See bin/tasks/general/check-environment.js
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
const enabled = ctx => ctx.apiEnv === false;

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
    getSchema,
    getUser,
    getPassword
  ]);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
