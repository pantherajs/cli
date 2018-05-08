/**
 * @file bin/utils/query-enabled.js
 */
'use strict';

/**
 * Determines whether or not a task that performs a SQL operation may run.
 * Those types of tasks must have a client object attached to the task context
 * object, and the client must be ready to send queries. This checking function
 * should be included with all of the tasks in bin/tasks/sql.
 * @param  {Object} ctx
 * @return {Boolean}
 * @private
 */
module.exports = ctx => {
  return Object.prototype.hasOwnProperty.call(ctx, 'client')
    && (ctx.client.readyForQuery === true);
};
