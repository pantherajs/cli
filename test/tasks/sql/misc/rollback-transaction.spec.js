/**
 * @file test/tasks/sql/misc/rollback-transaction.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  '../../../utils/sql-task': sinon.stub().resolves()
};

const rollback = proxyquire('../../../../bin/tasks/sql/misc/rollback-transaction', stubs);

const context = () => {
  return ;
};

test('should only be enabled if `ctx.error` is true', t => {
  const context = {
    parent: {
      task: {},
      title: 'title',
      start: process.hrtime()
    }
  };

  context.error = true;
  t.true(rollback.enabled(context));

  context.error = false;
  t.false(rollback.enabled(context));
});

test('should rollback database transaction', async t => {
  const context = {
    parent: {
      task: {},
      title: 'title',
      start: process.hrtime()
    }
  };

  await t.notThrows(() => rollback.task(context));
});

test('should set `ctx.inTransaction` to false', async t => {
  const context = {
    parent: {
      task: {},
      title: 'title',
      start: process.hrtime()
    }
  };

  await t.notThrows(() => rollback.task(context));
  t.false(context.inTransaction);
});
