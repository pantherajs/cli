/**
 * @file test/tasks/general/disconnect-from-database.spec.js
 */
'use strict';

const test  = require('ava');
const sinon = require('sinon');

const stubs = {
  pg: {
    Client: function() {}
  }
};

stubs.pg.Client.prototype.end = sinon.stub().resolves();

const disconnect = require('../../../bin/tasks/general/disconnect-from-database');

test('should only be enabled if `ctx.connected` is true', t => {
  const ctx = {
    client: new stubs.pg.Client()
  };

  ctx.connected = true;
  t.true(disconnect.enabled(ctx));

  ctx.connected = false;
  t.false(disconnect.enabled(ctx));
});

test('should call `ctx.client.end`', async t => {
  stubs.pg.Client.prototype.end.resetHistory;

  const ctx = {
    client: new stubs.pg.Client()
  };
  const task = {
    title: 'title'
  };

  await disconnect.task(ctx, task);
  t.true(ctx.client.end.called);
});
