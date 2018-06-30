/**
 * @file bin/tasks/sql/seed/roles.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Seeding default roles...';

/**
 * @type {String}
 */
const file = 'seed/roles.sql';

/**
 * @param  {Object} ctx
 * @return {Promise}
 * @private
 */
const task = ctx => sqlTask(ctx, file);

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
