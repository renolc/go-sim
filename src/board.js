import _ from 'underscore'

import cell from './cell'

export default (s = 9) => {
  const size = s

  const state = _.flatten(_.times(size, (row) => {
    return _.times(size, (col) => {
      return cell(row, col)
    })
  }))

  return {
    state,

    at(row, col) {
      return (row < 0 || row >= size || col < 0 || col >= size)
        ? undefined
        : state[size * row + col]
    }
  }
}