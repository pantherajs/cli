/**
 * @file test/tasks/sql/misc/commit-transaction.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const include = proxyquire('../../../../bin/tasks/sql/misc/commit-transaction', stubs);

test('should only be enabled if `ctx.error` is false', t => {
  const context = {
    client: {
      readyForQuery: true
    }
  };

  context.error = false;
  t.true(include.enabled(context));

  context.error = true;
  t.false(include.enabled(context));
});

test('should commit database transaction', async t => {
  const context = {
    parent: {
      task: {},
      title: 'title',
      start: process.hrtime()
    }
  };

  await t.notThrows(() => include.task(context));
});

test('should set `ctx.inTransaction` to false', async t => {
  const context = {
    parent: {
      task: {},
      title: 'title',
      start: process.hrtime()
    }
  };

  await t.notThrows(() => include.task(context));
  t.false(context.inTransaction);
});
