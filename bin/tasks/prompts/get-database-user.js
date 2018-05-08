/**
 * @file bin/tasks/prompts/get-database-user.js
 */
'use strict';

const input = require('listr-input');

const pad = require('../../utils/pad');

/**
 * @type {String}
 */
const title = 'Enter database user';

/**
 * Prompts for the name of the database user to connect with. Intended to run
 * in a series of subtasks, hence the reference to the parent task.
 * @param  {Object} ctx
 * @return {Observable}
 * @private
 */
const task = ctx => {
  const { task, title } = ctx.parent;
  task.title = pad(title, '(1 of 5)');

  return input('User: ', {
    default:  'postgres',
    validate: result => result.length > 0,
    done:     result => ctx.env.PANTHERA_DB_USER = result
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, task };
