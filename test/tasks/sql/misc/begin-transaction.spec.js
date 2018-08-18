/**
 * @file test/tasks/sql/misc/begin-transaction.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../bin/tasks/sql/misc/begin-transaction', stubs);

test('should begin database transaction', async t => {
  await t.notThrows(() => include.task({}));
});

test('should set `ctx.inTransaction` to true', async t => {
  const context = {};

  await include.task(context);
  t.true(context.inTransaction);
});
