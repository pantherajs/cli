/**
 * @file test/tasks/general/get-configuration.spec.js
 */
'use strict';

const test  = require('ava');
const sinon = require('sinon');

const include = require('../../../bin/tasks/general/get-configuration');

test('should only run if `ctx.apiEnv` is false', t => {
  t.true(include.enabled({
    apiEnv: false
  }));

  t.false(include.enabled({
    apiEnv: true
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
