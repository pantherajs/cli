/**
 * @file test/tasks/prompts/get-database-port.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  'listr-input': sinon.stub().returnsArg(1)
};

const include = proxyquire('../../../bin/tasks/prompts/get-database-port', stubs);

test('should validate only if input.length > 0 && !isNaN(input)', t => {
  const context = {
    env: {},
    parent: {
      task: {},
      title: 'title'
    }
  };
  const task = {};

  const result = include.task(context, task);
  t.false(result.validate('hello, world'));
  t.true(result.validate('5432'));
});

test('should set `ctx.env.PANTHERA_DB_PORT`', t => {
  const context = {
    env: {},
    parent: {
      task: {},
      title: 'title'
    }
  };
  const task = {};

  include.task(context, task).done('5432');
  t.true(context.env.PANTHERA_DB_PORT === 5432);
});

test('should remove `ctx.parent`', t => {
  const context = {
    env: {},
    parent: {
      task: {},
      title: 'title'
    }
  };
  const task = {};

  include.task(context, task).done('5432');
  t.falsy(context.parent);
});
