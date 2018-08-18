/**
 * @file test/tasks/sql/triggers/after/update-permission.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../../bin/tasks/sql/triggers/after/update-permission', stubs);

test('should create `update_permission` trigger', async t => {
  await t.notThrows(() => include.task({}));
});
