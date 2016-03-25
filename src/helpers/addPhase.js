export default (state) => {
  const boundPhase = require(`../phases/${state.phase}`)(state)
  Object.keys(boundPhase).forEach((key) => state[key] = boundPhase[key])
}