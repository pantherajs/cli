/**
 * @file test/tasks/sql/types/alias-type.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const aliasType = proxyquire('../../../../bin/tasks/sql/types/alias-type', stubs);

test('should create `alias_type` type', async t => {
  await t.notThrows(() => aliasType.task({}));
});
