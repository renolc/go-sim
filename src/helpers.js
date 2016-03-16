export const stateProps = (props) => {
  const state = {}
  const obj = {}

  Object.keys(props).forEach((key) => {
    state[key] = props[key]

    Object.defineProperty(obj, key, {
      get: () => state[key],
      set: (val) => state[key] = val,
      enumerable: true
    })
  })

  return { state, obj }
}

export const range = (size) => Array.from(Array(size), (v, k) => k)