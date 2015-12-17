import stateProps from './helpers/state-props'

export const piece = Object.freeze({
  EMPTY: 'empty',
  BLACK: 'black',
  WHITE: 'white'
})

export default (row, col) => {
  const { state, obj } = stateProps({
    row,
    col,
    value: piece.EMPTY
  })

  obj.serialize = () => state

  obj.is = (value) => state.value === value

  obj.set = (value) => state.value = value

  return obj
}