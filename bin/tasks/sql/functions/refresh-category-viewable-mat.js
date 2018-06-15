/**
 * @file bin/tasks/sql/functions/refresh-category-viewable-mat.js
 */
'use strict';

const enabled = require('../../../utils/query-enabled');
const sqlTask = require('../../../utils/sql-task');

/**
 * @type {String}
 */
const title = 'Creating `refresh_category_viewable_mat` function...';

/**
 * @type {String}
 */
const file = 'functions/refresh-category-viewable-mat.sql';

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
