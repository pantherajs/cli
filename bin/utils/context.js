/**
 * @file bin/utils/context.js
 */
'use strict';

/**
 * @return {Object}
 */
module.exports = () => {
  return {
    connected: false,
    env:       Object.assign({}, process.env),
    error:     false
  };
};
