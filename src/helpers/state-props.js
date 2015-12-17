import _ from 'underscore'

export default (props) => {
  const state = {}
  const obj = {}

  _.each(props, (value, key) => {
    state[key] = value

    Object.defineProperty(obj, key, {
      get: () => state[key],
      set: (val) => state[key] = val
    })
  })

  return { state, obj }
}