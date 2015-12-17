import _ from 'underscore'

import cell from './cell'
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

  obj.clusterAt = (row, col, clust) => {
    const cell = obj.at(row, col)
    if (!cell) {
      return undefined
    }

    let cluster = clust || []
    cluster.push(cell)

    _.each(_.range(-1, 2), (offset) => {
      const dr = row + offset
      const dc = col + offset

      const vertical = obj.at(dr, col)
      const horizontal = obj.at(row, dc)

      const value = cell.value

      if (vertical && vertical.is(value) && !_.contains(cluster, vertical)) {
        cluster = obj.clusterAt(dr, col, cluster)
      }

      if (horizontal && horizontal.is(value) && !_.contains(cluster, horizontal)) {
        cluster = obj.clusterAt(row, dc, cluster)
      }
    })

    return cluster
  }

  return obj
}