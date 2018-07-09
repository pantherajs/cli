/**
 * @file test/tasks/sql/triggers/after/delete-category-permission.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../../bin/tasks/sql/triggers/after/delete-category-permission', stubs);

test('should create `delete_category_permission` trigger', async t => {
  await t.notThrows(() => include.task({}));
});
