/**
 * @file test/tasks/sql/triggers/before/enforce-noncircular-parent-forum-reference.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../../bin/tasks/sql/triggers/before/enforce-noncircular-parent-forum-reference', stubs);

test('should create `enforce_noncircular_parent_forum_reference` trigger', async t => {
  await t.notThrows(() => include.task({}));
});
