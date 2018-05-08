/**
 * @file bin/tasks/prompts/get-database-name.js
 */
'use strict';

const input = require('listr-input');

const pad = require('../../utils/pad');

/**
 * @type {String}
 */
const title = 'Enter database name';

/**
 * Prompts for the database name to connect to. Intended to run in a series of
 * subtasks, hence the reference to the parent task.
 * @param  {Object} ctx
 * @return {Observable}
 * @private
 */
const task = ctx => {
  const { task, title } = ctx.parent;
  task.title = pad(title, '(3 of 5)');

  return input('Database: ', {
    default:  'postgres',
    validate: result => result.length > 0,
    done:     result => ctx.env.PANTHERA_DB_NAME = result
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, task };
