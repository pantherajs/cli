/**
 * @file test/tasks/sql/triggers/after/insert-account.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../../utils/sql-task': sinon.stub().resolves()
};

const insert = proxyquire('../../../../../bin/tasks/sql/triggers/after/insert-account', stubs);

test('should create `insert_account` trigger', async t => {
  await t.notThrows(() => insert.task({}));
});
