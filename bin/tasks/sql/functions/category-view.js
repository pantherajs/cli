/**
 * @file bin/tasks/sql/functions/category-view.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `category_view` function...';

/**
 * @type {String}
 */
const file = 'functions/category-view.sql';

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
