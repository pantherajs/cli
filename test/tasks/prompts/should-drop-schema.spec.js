/**
 * @file test/tasks/prompts/should-drop-schema.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {
  'listr-input':               sinon.stub().returnsArg(1),
  '../../utils/query-enabled': sinon.stub().returns(true)
};

const include = proxyquire('../../../bin/tasks/prompts/should-drop-schema', stubs);

test('should be enabled if `ctx.schemaExists` is true', t => {
  const context = {
    schemaExists: true
  };

  t.true(include.enabled(context));
});

test('should accept only `Y` or `n` as input', t => {
  const context = {
    env: {
      PANTHERA_SCHEMA: 'schema'
    }
  };
  const task = {};

  const result = include.task(context, task);
  t.true(result.validate('Y'));
  t.true(result.validate('n'));
});

test('should set `ctx.dropSchema` to true if input is `Y`', t => {
  const context = {
    env: {
      PANTHERA_SCHEMA: 'schema'
    }
  };
  const task = {};

  include.task(context, task).done('Y');
  t.true(context.dropSchema);
});

test('should set `ctx.dropSchema` to false if input is `n`', t => {
  const context = {
    env: {
      PANTHERA_SCHEMA: 'schema'
    }
  };
  const task = {};

  include.task(context, task).done('n');
  t.false(context.dropSchema);
});
