/**
 * @file test/tasks/sql/triggers/insert-role.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const insert = proxyquire('../../../../bin/tasks/sql/triggers/insert-role', stubs);

test('should create `insert_role` trigger', async t => {
  await t.notThrows(() => insert.task({}));
});
