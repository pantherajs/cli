/**
 * @file test/tasks/sql/types/permission-type.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../bin/tasks/sql/types/permission-type', stubs);

test('should create `permission_type` type', async t => {
  await t.notThrows(() => include.task({}));
});
