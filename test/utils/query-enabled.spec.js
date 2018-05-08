/**
 * @file test/utils/query-enabled.spec.js
 */
'use strict';

const test = require('ava');

const enabled = require('../../bin/utils/query-enabled');

test('should return true if `ctx.client` and `ctx.client.readyForQuery`', t => {
  t.true(enabled({
    client: {
      readyForQuery: true
    }
  }));
});

test('should return false if `ctx.client` alone', t => {
  t.false(enabled({
    client: {}
  }));
});

test('should return false without `ctx.client`', t => {
  t.false(enabled({}));
});
