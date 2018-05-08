/**
 * @file bin/utils/has.js
 */
'use strict';

/**
 * Returns whether a specified object has all of the specified properties.
 * @param  {Object}    object
 * @param  {...String} properties
 * @return {Boolean}
 * @private
 */
module.exports = function has(object, ...properties) {
  return properties.reduce((has, property) => {
    return has && Object.prototype.hasOwnProperty.call(object, property);
  }, true);
};
