/**
 * @file test/tasks/sql/types/resource-type.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../bin/tasks/sql/types/resource-type', stubs);

test('should create `resource_type` type', async t => {
  await t.notThrows(() => include.task({}));
});
