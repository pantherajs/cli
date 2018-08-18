/**
 * @file test/tasks/sql/triggers/after/delete-alias.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../../bin/tasks/sql/triggers/after/delete-alias', stubs);

test('should create `delete_alias` trigger', async t => {
  await t.notThrows(() => include.task({}));
});
