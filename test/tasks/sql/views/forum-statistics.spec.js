/**
 * @file test/tasks/sql/views/forum-statistics.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const forumStats = proxyquire('../../../../bin/tasks/sql/views/forum-statistics', stubs);

test('should create `forum_statistics` view', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => forumStats.task(context));
});
