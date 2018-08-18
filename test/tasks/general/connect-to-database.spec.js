/**
 * @file test/tasks/general/connect-to-database.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  pg: {
    Client: function() {}
  }
};

stubs.pg.Client.prototype.connect = sinon.stub().resolves();

const include = proxyquire('../../../bin/tasks/general/connect-to-database', stubs);

test('should set `ctx.client`', async t => {
  const ctx = {
    env: {}
  };
  const task = {
    title: 'title'
  };

  await include.task(ctx, task);
  t.truthy(ctx.client);
});

test('should call `ctx.client.connect`', async t => {
  stubs.pg.Client.prototype.connect.resetHistory;

  const ctx = {
    env: {}
  };
  const task = {
    title: 'title'
  };

  await include.task(ctx, task);
  t.true(ctx.client.connect.called);
});
