/**
 * @file test/unit/bin/commands/start.spec.js
 */
'use strict';

const test       = require('ava');
const proxyquire = require('proxyquire');
const sinon      = require('sinon');

const stubs = {};

const start = proxyquire('../../bin/commands/start', stubs);

test('should not throw', async t => {
  await t.notThrows(() => {
    return start.handler();
  });
});
