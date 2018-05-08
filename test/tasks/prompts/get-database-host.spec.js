/**
 * @file test/tasks/prompts/get-database-host.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  'listr-input': sinon.stub().returnsArg(1)
};

const get = proxyquire('../../../bin/tasks/prompts/get-database-host', stubs);

test('should validate only if input.length > 0', t => {
  const context = {
    env: {},
    parent: {
      task: {},
      title: 'title'
    }
  };
  const task = {};

  const result = get.task(context, task);
  t.true(result.validate('hello, world'));
  t.false(result.validate(''));
});

test('should set `ctx.env.PANTHERA_DB_HOST`', t => {
  const context = {
    env: {},
    parent: {
      task: {},
      title: 'title'
    }
  };
  const task = {};

  const result = get.task(context, task);
  result.done('hello, world');
  t.true(context.env.PANTHERA_DB_HOST === 'hello, world');
});
