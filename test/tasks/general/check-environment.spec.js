/**
 * @file test/tasks/general/check-environment.spec.js
 */
'use strict';

const test = require('ava');

const checkEnvironment = require('../../../bin/tasks/general/check-environment');

test('should set `ctx.dbEnv` to true if all five environment variables set', t => {
  const ctx = {
    env: {}
  };

  ctx.env['PANTHERA_DB_USER'] = 'user';
  ctx.env['PANTHERA_DB_PASS'] = 'password';
  ctx.env['PANTHERA_DB_NAME'] = 'database';
  ctx.env['PANTHERA_DB_HOST'] = 'host';
  ctx.env['PANTHERA_DB_PORT'] = 'port';

  checkEnvironment.task(ctx, {});
  t.true(ctx.dbEnv);
});

test('should set `ctx.dbEnv` to false if any environment variable not set', t => {
  const ctx = {
    env: {}
  };

  ctx.env['PANTHERA_DB_USER'] = 'user';
  ctx.env['PANTHERA_DB_PASS'] = 'password';
  ctx.env['PANTHERA_DB_NAME'] = 'database';
  ctx.env['PANTHERA_DB_HOST'] = 'host';

  checkEnvironment.task(ctx, {});
  t.false(ctx.dbEnv);
});

test('should set `ctx.apiEnv` to true if all three environment variables set', t => {
  const ctx = {
    env: {}
  };

  ctx.env['PANTHERA_SCHEMA'] = 'schema';
  ctx.env['PANTHERA_API_USER'] = 'user';
  ctx.env['PANTHERA_API_PASS'] = 'password';

  checkEnvironment.task(ctx, {});
  t.true(ctx.apiEnv);
});

test('should set `ctx.apiEnv` to false if any environment variable not set', t => {
  const ctx = {
    env: {}
  };

  ctx.env['PANTHERA_API_USER'] = 'user';
  ctx.env['PANTHERA_API_PASS'] = 'password';

  checkEnvironment.task(ctx, {});
  t.false(ctx.apiEnv);
});
