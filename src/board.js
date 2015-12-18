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

  obj.clusterAt = (row, col, { cluster = [], liberties = [] } = {}) => {
    const cell = obj.at(row, col)
    if (!cell) {
      return undefined
    }

    cluster.push(cell)

    _.each(_.range(-1, 2), (offset) => {
      const dr = row + offset
      const dc = col + offset

      const vertical = obj.at(dr, col)
      const horizontal = obj.at(row, dc)

      const value = cell.value

      // add neighbor cells of same value or liberties
      if (vertical) {
        if (vertical.is(value) && !_.contains(cluster, vertical)) {
          ({ cluster, liberties } = obj.clusterAt(dr, col, { cluster, liberties }))
        } else if (vertical.is(piece.EMPTY) && !_.contains(liberties, vertical)) {
          liberties.push(vertical)
        }
      }

      if (horizontal) {
        if (horizontal.is(value) && !_.contains(cluster, horizontal)) {
          ({ cluster, liberties } = obj.clusterAt(row, dc, { cluster, liberties }))
        } else if (horizontal.is(piece.EMPTY) && !_.contains(liberties, horizontal)) {
          liberties.push(horizontal)
        }
      }
    })

    return { cluster, liberties }
  }

  return obj
}