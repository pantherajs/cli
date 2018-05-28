/**
 * @file test/tasks/sql/triggers/noncircular-parent-forum-reference.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const noncircular = proxyquire('../../../../bin/tasks/sql/triggers/noncircular-parent-forum-reference', stubs);

test('should create `noncircular_parent_forum_reference` trigger', async t => {
  await t.notThrows(() => noncircular.task({}));
});
