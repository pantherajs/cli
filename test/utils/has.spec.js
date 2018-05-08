/**
 * @file test/unit/bin/utils/has.spec.js
 */
'use strict';

const test = require('ava');
const has  = require('../../bin/utils/has');

const obj = {
  one: true,
  two: true
};

test('should be a function', t => {
  t.true(typeof has === 'function');
});

test('should return true for properties that exist', t => {
  t.true(has(obj, 'one', 'two'));
});

test('should return false for properties that don\'t exist', t => {
  t.false(has(obj, 'three'));
});
