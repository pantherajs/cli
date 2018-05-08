/**
 * @file test/tasks/general/get-database-credentials.spec.js
 */
'use strict';

const test  = require('ava');
const sinon = require('sinon');

const get = require('../../../bin/tasks/general/get-database-credentials');

test('should only run if `ctx.dbEnv` is false', t => {
  t.true(get.enabled({
    dbEnv: false
  }));

  t.false(get.enabled({
    dbEnv: true
  }));
});

test('should set `ctx.parent`', async t => {
  const context = {};
  const task = {
    title: 'title'
  };

  get.task(context, task);
  t.truthy(context.parent);
});
