/**
 * @file test/tasks/sql/triggers/distinct-parent-forum-reference.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const distinct = proxyquire('../../../../bin/tasks/sql/triggers/distinct-parent-forum-reference', stubs);

test('should create `distinct_parent_forum_reference` trigger', async t => {
  await t.notThrows(() => distinct.task({}));
});
