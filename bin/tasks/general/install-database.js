/**
 * @file bin/tasks/general/install-database.js
 */
'use strict';

const Listr = require('listr');

const beginTransaction          = require('../sql/misc/begin-transaction');
const dropSchema                = require('../sql/misc/drop-schema');
const createSchema              = require('../sql/misc/create-schema');
const createApiUser             = require('../sql/misc/create-api-user');
const grantUserPermissions      = require('../sql/misc/grant-user-permissions');
const setSearchPath             = require('../sql/misc/set-search-path');
const uuidFunction              = require('../sql/functions/uuid');
const aliasType                 = require('../sql/types/alias-type');
const updateModifiedTrigger     = require('../sql/triggers/update-modified-column');
const accountTable              = require('../sql/tables/account');
const insertAccountTrigger      = require('../sql/triggers/insert-account');
const accessTokenTable          = require('../sql/tables/access-token');
const roleTable                 = require('../sql/tables/role');
const updateRoleTrigger         = require('../sql/triggers/update-role');
const deleteRoleTrigger         = require('../sql/triggers/delete-role');
const aliasTable                = require('../sql/tables/alias');
const aliasStatsMat             = require('../sql/tables/alias-statistics-mat');
const insertAliasTrigger        = require('../sql/triggers/insert-alias');
const updateAliasTrigger        = require('../sql/triggers/update-alias');
const deleteAliasTrigger        = require('../sql/triggers/delete-alias');
const refreshAliasStatsFunction = require('../sql/functions/refresh-alias-statistics-mat');
const aliasStatsView            = require('../sql/views/alias-statistics');
const categoryTable             = require('../sql/tables/category');
const insertCategoryTrigger     = require('../sql/triggers/insert-category');
const forumTable                = require('../sql/tables/forum');
const ancestorForumsFunction    = require('../sql/functions/ancestor-forums');
const descendantForumsFunction  = require('../sql/functions/descendant-forums');
const distinctReference         = require('../sql/triggers/distinct-parent-forum-reference');
const noncircularReference      = require('../sql/triggers/noncircular-parent-forum-reference');
const topicTable                = require('../sql/tables/topic');
const postTable                 = require('../sql/tables/post');
const topicStatsMatTable        = require('../sql/tables/topic-statistics-mat');
const refreshTopicStatsFunction = require('../sql/functions/refresh-topic-statistics-mat');
const topicStatsView            = require('../sql/views/topic-statistics');
const forumStatsMatTable        = require('../sql/tables/forum-statistics-mat');
const refreshForumStatsFunction = require('../sql/functions/refresh-forum-statistics-mat');
const forumStatsView            = require('../sql/views/forum-statistics');
const deletePostTrigger         = require('../sql/triggers/delete-post');
const deleteTopicTrigger        = require('../sql/triggers/delete-topic');
const insertForumTrigger        = require('../sql/triggers/insert-forum');
const insertPostTrigger         = require('../sql/triggers/insert-post');
const insertTopicTrigger        = require('../sql/triggers/insert-topic');
const updateForumTrigger        = require('../sql/triggers/update-forum');
const updateTopicTrigger        = require('../sql/triggers/update-topic');
const updatePostTrigger         = require('../sql/triggers/update-post');
const categoryPermTable         = require('../sql/tables/category-permission');
const updateCategoryPermTrigger = require('../sql/triggers/update-category-permission');
const categoryViewableMatTable  = require('../sql/tables/category-viewable-mat');
const refreshCategoryViewableFunction = require('../sql/functions/refresh-category-viewable-mat');
const categoryViewableView      = require('../sql/views/category-viewable');
const forumViewableMatTable     = require('../sql/tables/forum-viewable-mat');
const refreshForumViewableFunction    = require('../sql/functions/refresh-forum-viewable-mat');
const forumViewableView         = require('../sql/views/forum-viewable');
const forumPermTable            = require('../sql/tables/forum-permission');
const updateForumPermTrigger    = require('../sql/triggers/update-forum-permission');
const forumViewFunction         = require('../sql/functions/forum-view');
const seedRoles                 = require('../sql/seed/roles');
const commitTransaction         = require('../sql/misc/commit-transaction');
const rollbackTransaction       = require('../sql/misc/rollback-transaction');

/**
 * @type {Array.<Object>}
 */
const tasks = [
  beginTransaction,
  dropSchema,
  createSchema,
  createApiUser,
  grantUserPermissions,
  setSearchPath,
  uuidFunction,
  aliasType,
  updateModifiedTrigger,
  accountTable,
  insertAccountTrigger,
  accessTokenTable,
  roleTable,
  updateRoleTrigger,
  deleteRoleTrigger,
  aliasTable,
  insertAliasTrigger,
  updateAliasTrigger,
  deleteAliasTrigger,
  categoryTable,
  insertCategoryTrigger,
  categoryPermTable,
  updateCategoryPermTrigger,
  categoryViewableMatTable,
  refreshCategoryViewableFunction,
  categoryViewableView,
  forumTable,
  forumPermTable,
  updateForumPermTrigger,
  distinctReference,
  noncircularReference,
  ancestorForumsFunction,
  descendantForumsFunction,
  insertForumTrigger,
  updateForumTrigger,
  forumViewableMatTable,
  refreshForumViewableFunction,
  forumViewableView,
  topicTable,
  deleteTopicTrigger,
  insertTopicTrigger,
  updateTopicTrigger,
  postTable,
  deletePostTrigger,
  insertPostTrigger,
  updatePostTrigger,
  aliasStatsMat,
  refreshAliasStatsFunction,
  aliasStatsView,
  topicStatsMatTable,
  refreshTopicStatsFunction,
  topicStatsView,
  forumStatsMatTable,
  refreshForumStatsFunction,
  forumStatsView,
  forumViewFunction,
  seedRoles,
  commitTransaction,
  rollbackTransaction
];

/**
 * @type {String}
 */
const title = 'Installing database...';

/**
 * @param  {Object} ctx
 * @return {Boolan}
 * @private
 */
const enabled = ctx => ctx.connected === true;

/**
 * @param  {Object} ctx
 * @param  {Object} task
 * @return {Listr}
 * @private
 */
const task = (ctx, task) => {
  const schema = ctx.env.PANTHERA_SCHEMA;

  ctx.parent = {
    start: process.hrtime(),
    title: `Installing database into \`${schema}\`...`,
    task
  };

  task.title = ctx.parent.title;

  return new Listr(tasks);
};

/**
 * A Listr-compatible task object.
 * @type {Object}
 */
module.exports = { title, enabled, task };
