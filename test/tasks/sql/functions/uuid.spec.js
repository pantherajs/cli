/**
 * @file test/tasks/sql/functions/uuid.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const uuid = proxyquire('../../../../bin/tasks/sql/functions/uuid', stubs);

test('should create `uuid` function', async t => {
  await t.notThrows(() => uuid.task({}));
});
