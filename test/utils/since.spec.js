/**
 * @file test/unit/bin/utils/since.spec.js
 */
'use strict';

const test  = require('ava');
const since = require('../../bin/utils/since');

test('should be a function', t => {
  t.true(typeof since === 'function');
});

test('should return a Number', t => {
  const result = since(process.hrtime());

  t.true(typeof result === 'number');
});

test('number should have fewer than 4 decimals', t => {
  const result = since(process.hrtime());

  t.true(result.toString().split('.')[1].length < 4);
});
