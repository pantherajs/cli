/**
 * @file test/tasks/sql/triggers/after/insert-forum.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../../utils/sql-task': sinon.stub().resolves()
};

const insert = proxyquire('../../../../../bin/tasks/sql/triggers/after/insert-forum', stubs);

test('should create `insert_forum` trigger', async t => {
  await t.notThrows(() => insert.task({}));
});
