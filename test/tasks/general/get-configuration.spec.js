/**
 * @file test/tasks/general/get-configuration.spec.js
 */
'use strict';

const test  = require('ava');
const sinon = require('sinon');

const get = require('../../../bin/tasks/general/get-configuration');

test('should only run if `ctx.apiEnv` is false', t => {
  t.true(get.enabled({
    apiEnv: false
  }));

  t.false(get.enabled({
    apiEnv: true
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
