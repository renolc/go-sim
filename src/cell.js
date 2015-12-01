export const piece = Object.freeze({
  EMPTY: 'empty',
  BLACK: 'black',
  WHITE: 'white'
})

export default (row, col) => {
  const state = {
    row,
    col,
    value: piece.EMPTY
  }

  return {
    serialize() {
      return state
    },

    get(key) {
      return state[key]
    },

    is(value) {
      return state.value === value
    },

    set(value) {
      state.value = value
    }
  }
}