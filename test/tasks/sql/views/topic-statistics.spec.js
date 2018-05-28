/**
 * @file test/tasks/sql/views/topic-statistics.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const topicStats = proxyquire('../../../../bin/tasks/sql/views/topic-statistics', stubs);

test('should create `topic_statistics` view', async t => {
  const context = {
    env: {
      PANTHERA_API_USER: 'user'
    }
  };

  await t.notThrows(() => topicStats.task(context));
});
