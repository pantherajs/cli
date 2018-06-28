/**
 * @file test/tasks/sql/triggers/update-forum-permission.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const update = proxyquire('../../../../bin/tasks/sql/triggers/update-forum-permission', stubs);

test('should create `update_forum_permission` trigger', async t => {
  await t.notThrows(() => update.task({}));
});
