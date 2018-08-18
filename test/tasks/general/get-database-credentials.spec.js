/**
 * @file test/tasks/general/get-database-credentials.spec.js
 */
'use strict';

const test  = require('ava');
const sinon = require('sinon');

const include = require('../../../bin/tasks/general/get-database-credentials');

test('should only run if `ctx.dbEnv` is false', t => {
  t.true(include.enabled({
    dbEnv: false
  }));

  t.false(include.enabled({
    dbEnv: true
  }));
});

test('should set `ctx.parent`', async t => {
  const context = {};
  const task = {
    title: 'title'
  };

  include.task(context, task);
  t.truthy(context.parent);
});
