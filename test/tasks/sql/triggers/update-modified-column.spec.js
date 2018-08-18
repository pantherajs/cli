/**
 * @file test/tasks/sql/triggers/update-modified-column.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../bin/tasks/sql/triggers/update-modified-column', stubs);

test('should create `update_modified_column` trigger', async t => {
  await t.notThrows(() => include.task({}));
});
