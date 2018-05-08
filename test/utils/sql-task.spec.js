/**
 * @file test/utils/sql-task.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  format: sinon.stub(),
  path: {
    join: sinon.stub()
  },
  sander: {
    readFile: sinon.stub().resolves('sql')
  }
};

const task = proxyquire('../../bin/utils/sql-task', stubs);

test.serial.afterEach(() => {
  stubs.format.reset();
  stubs.path.join.reset();
  stubs.sander.readFile.resetHistory();
});

test.serial('should call `sander#readFile`', async t => {
  const context = {
    client: {
      query: sinon.stub().resolves()
    }
  };

  await task(context, 'file');
  t.true(stubs.sander.readFile.callCount === 1);
});

test.serial('should call `ctx.client#query`', async t => {
  const context = {
    client: {
      query: sinon.stub().resolves()
    }
  };

  await task(context, 'file');
  t.true(context.client.query.callCount === 1);
});

test.serial('should set `ctx.error` to true on error', async t => {
  const context = {
    client: {
      query: sinon.stub().rejects()
    }
  };

  await t.throws(() => task(context, 'file'));
  t.true(context.error);
});
