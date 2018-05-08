/**
 * @file test/unit/bin/utils/pad.spec.js
 */
'use strict';

const test = require('ava');
const pad  = require('../../bin/utils/pad');

test('should be a function', t => {
  t.true(typeof pad === 'function');
});

test('should return a padded, appended string', t => {
  t.is(pad('hello', 'world'), 'hello'.padEnd(50) + 'world');
});
