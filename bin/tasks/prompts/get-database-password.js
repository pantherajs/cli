/**
 * @file bin/tasks/prompts/get-database-password.js
 */
'use strict';

const input = require('listr-input');

const pad = require('../../utils/pad');

/**
 * @type {String}
 */
const title = 'Enter database password';

/**
 * Prompts for the password of the database user to connect with. Intended to
 * run in a series of subtasks, hence the reference to the parent task.
 * @param  {Object} ctx
 * @return {Observable}
 * @private
 */
const task = ctx => {
  const { task, title } = ctx.parent;
  task.title = pad(title, '(2 of 5)');

  return input('Password: ', {
    secret:   true,
    validate: result => result.length > 0,
    done:     result => ctx.env.PANTHERA_DB_PASS = result
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, task };
