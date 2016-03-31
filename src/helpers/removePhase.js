require('../phases/play')
require('../phases/mark')
require('../phases/end')

export default (state) => Object.keys(require(`../phases/${state.phase}`)(state)).forEach((key) => delete state[key])
