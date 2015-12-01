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
        cells: _.reduce(state.cells, (list, cell) => {
          list.push(cell.serialize())
          return list
        }, [])
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