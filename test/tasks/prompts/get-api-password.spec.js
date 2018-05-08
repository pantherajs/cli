/**
 * @file test/tasks/prompts/get-api-password.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  'listr-input': sinon.stub().returnsArg(1)
};

const get = proxyquire('../../../bin/tasks/prompts/get-api-password', stubs);

test('should validate only if input.length > 0', t => {
  const context = {
    api: {},
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

test('should set `ctx.api.password`', t => {
  const context = {
    api: {},
    parent: {
      task: {},
      title: 'title'
    }
  };
  const task = {};

  get.task(context, task).done('hello, world');
  t.true(context.api.password === 'hello, world');
});
