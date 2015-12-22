import _ from 'underscore'

import cell, { piece } from './cell'

import stateProps from './helpers/state-props'

export default (size = 9) => {
  const { state, obj } = stateProps({
    size,
    cells: _.flatten(_.times(size, (row) => {
      return _.times(size, (col) => {
        return cell(row, col)
      })
    }))
  })

  obj.serialize = () => {
    return {
      size: state.size,
      cells: _.map(state.cells, (cell) => cell.serialize())
    }
  }

  obj.at = (row, col) => {
    return (row < 0 || row >= state.size || col < 0 || col >= state.size)
      ? undefined
      : state.cells[state.size * row + col]
  }

  obj.neighborCells = (row, col) => {
    const cell = obj.at(row, col)
    if (!cell) {
      return undefined
    }

    let neighbors = []

    _.each(_.range(-1, 2), (offset) => {
      const dr = row + offset
      const dc = col + offset

      const vertical = obj.at(dr, col)
      const horizontal = obj.at(row, dc)

      if (vertical) {
        neighbors.push(vertical)
      }
      if (horizontal) {
        neighbors.push(horizontal)
      }
    })

    return neighbors
  }

  obj.clusterAt = (row, col, { cluster = [], liberties = [] } = {}) => {
    const cell = obj.at(row, col)
    if (!cell) {
      return undefined
    }

    cluster.push(cell)

    const value = cell.value
    _.each(obj.neighborCells(row, col), (neighbor) => {
      if (neighbor.is(value) && !_.contains(cluster, neighbor)) {
        ({ cluster, liberties } = obj.clusterAt(neighbor.row, neighbor.col, { cluster, liberties}))
      } else if (neighbor.is(piece.EMPTY) && !_.contains(liberties, neighbor)) {
        liberties.push(neighbor)
      }
    })

    return { cluster, liberties}
  }

  obj.DEBUG = () => {
    return _.times(state.size, (row) => {
      return _.times(state.size, (col) => {
        if (obj.at(row, col).is(piece.EMPTY)) {
          return '-'
        } else if (obj.at(row, col).is(piece.BLACK)) {
          return 'b'
        } else {
          return 'w'
        }
      })
    })
  }

  return obj
}
