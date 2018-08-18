/**
 * @file test/tasks/prompts/get-database-user.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  'listr-input': sinon.stub().returnsArg(1)
};

const include = proxyquire('../../../bin/tasks/prompts/get-database-user', stubs);

test('should validate only if input.length > 0', t => {
  const context = {
    env: {},
    parent: {
      task: {},
      title: 'title'
    }
  };
  const task = {};

  const result = include.task(context, task);
  t.true(result.validate('hello, world'));
  t.false(result.validate(''));
});

test('should set `ctx.env.PANTHERA_DB_USER`', t => {
  const context = {
    env: {},
    parent: {
      task: {},
      title: 'title'
    }
  };
  const task = {};

  include.task(context, task).done('hello, world');
  t.true(context.env.PANTHERA_DB_USER === 'hello, world');
});
