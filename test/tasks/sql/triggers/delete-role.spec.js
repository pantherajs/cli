/**
 * @file test/tasks/sql/triggers/delete-role.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const deleteRole = proxyquire('../../../../bin/tasks/sql/triggers/delete-role', stubs);

test('should create `delete_role` trigger', async t => {
  await t.notThrows(() => deleteRole.task({}));
});
