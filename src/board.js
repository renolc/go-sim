import _ from 'underscore'

import cell from './cell'

export default (size = 9) => {
  const state = {
    size,
    cells: _.flatten(_.times(size, (row) => {
      return _.times(size, (col) => {
        return cell(row, col)
      })
    }))
  }

  return {
    serialize() {
      return {
        size: state.size,
        cells: _.map(state.cells, (cell) => cell.serialize())
      }
    },

    get(key) {
      return state[key]
    },

    at(row, col) {
      return (row < 0 || row >= state.size || col < 0 || col >= state.size)
        ? undefined
        : state.cells[state.size * row + col]
    }
  }
}