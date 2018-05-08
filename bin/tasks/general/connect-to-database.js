/**
 * @file bin/tasks/general/connect-to-database.js
 */
'use strict';

const { Client } = require('pg');

const pad = require('../../utils/pad');

/**
 * @type {String}
 */
const title = 'Connecting to PostgreSQL server...';

/**
 * Creates a single PostgreSQL client and uses it to connect to the database
 * using the configuration stored in ctx.options.
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Promise}
 * @private
 */
const task = (ctx, task) => {
  ctx.client = new Client({
    user:     ctx.env.PANTHERA_DB_USER,
    password: ctx.env.PANTHERA_DB_PASS,
    database: ctx.env.PANTHERA_DB_NAME,
    host:     ctx.env.PANTHERA_DB_HOST,
    port:     ctx.env.PANTHERA_DB_PORT
  });

  return ctx.client.connect().then(() => {
    ctx.connected = true;
    task.title = pad(task.title, 'success');
  });
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, task };
