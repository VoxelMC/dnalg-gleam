Date.now();

export function start() {
    return Date.now();
}

export function stop(startTime) {
    return Date.now() - startTime;
}

/**
 * @function split_test
 * @param {string} input
 * @returns {string}
 */
export function split_test(input) {
    return input.split("\n").join("");
}
