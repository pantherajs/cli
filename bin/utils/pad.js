/**
 * @file bin/utils/pad.js
 */
'use strict';

/**
 * Pads one string to the specified length, then appends another string at
 * the end of the newly-padded string. Used primarily to format task titles.
 * @param  {String} before
 * @param  {String} after
 * @param  {Number} [max=50]
 * @return {String}
 * @private
 */
module.exports = function pad(before, after, max = 50) {
  return before.padEnd(max) + after;
};
