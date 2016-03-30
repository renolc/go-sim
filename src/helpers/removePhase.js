export default (state) => Object.keys(require(`../phases/${state.phase}`)(state)).forEach((key) => delete state[key])
