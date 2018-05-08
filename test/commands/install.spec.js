/**
 * @file test/unit/bin/commands/install.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const listr = function() {};
listr.prototype.run = () => {};

const context = {
  client: {
    end:   sinon.stub().resolves(),
    query: sinon.stub().resolves()
  }
};

const stub = sinon.stub(listr.prototype, 'run');

const stubs = { listr };

const install = proxyquire('../../bin/commands/install', stubs);

test.serial('should not throw', async t => {
  stub.resolves();
  await t.notThrows(() => {
    return install.handler();
  });
  stub.reset();
});

test.serial('should swallow errors', async t => {
  stub.rejects();
  await t.notThrows(() => {
    return install.handler();
  });
  stub.reset();
});
