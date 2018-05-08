/**
 * @file test/tasks/general/check-postgres.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stub = sinon.stub();
const stubs = {
  execa: stub
};

const checkPostgres = proxyquire('../../../bin/tasks/general/check-postgres', stubs);

test.serial.afterEach(() => {
  stub.reset();
});

test.serial('should resolve if PostgreSQL >=10.x', async t => {
  stub.resolves({
    stdout: 'PostgreSQL 10.3'
  });

  const context = {};

  await checkPostgres.task(context, {
    title: 'title'
  });
  t.true(stub.callCount === 1);
  t.true(context.version === '10.3');
});

test.serial('should reject if PostgreSQL <10.x', async t => {
  stub.resolves({
    stdout: 'PostgreSQL 9.6'
  });

  const context = {};

  let tasl = {
    title: 'title'
  };

  await t.throws(checkPostgres.task(context, tasl));
  t.true(stub.callCount === 1);
  t.true(context.version === '9.6');
});

test.serial('should reject if PostgreSQL not found', async t => {
  stub.rejects();

  await t.throws(checkPostgres.task({}, {
    title: 'title'
  }));
  t.true(stub.callCount === 1);
});
