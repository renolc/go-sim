import { stateProps } from './helpers'

export const piece = Object.freeze({
  EMPTY: 'empty',
  BLACK: 'black',
  WHITE: 'white'
})

export default (row, col, value = piece.EMPTY) => {
  const { state, obj } = stateProps({
    row,
    col,
    value
  })

  obj.serialize = () => state

  obj.is = (value) => state.value === value

  obj.set = (value) => state.value = value

  return obj
}
