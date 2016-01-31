export default (props) => {
  const state = {}
  const obj = {}

  Object.keys(props).forEach((key) => {
    state[key] = props[key]

    Object.defineProperty(obj, key, {
      get: () => state[key],
      set: (val) => state[key] = val
    })
  })

  return { state, obj }
}
