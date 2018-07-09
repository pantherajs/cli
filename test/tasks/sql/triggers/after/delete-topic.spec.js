/**
 * @file test/tasks/sql/triggers/after/delete-topic.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../../utils/sql-task': sinon.stub().resolves()
};

const deleteTopic = proxyquire('../../../../../bin/tasks/sql/triggers/after/delete-topic', stubs);

test('should create `delete_topic` trigger', async t => {
  await t.notThrows(() => deleteTopic.task({}));
});
