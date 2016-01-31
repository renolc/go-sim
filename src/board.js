import cell, { piece } from './cell'

import stateProps from './helpers/state-props'

export default ({ size = 9, load = {} } = {}) => {
  const { state, obj } = stateProps({
    size: load.size || size,
    cells: (load.cells)
      ? load.cells.map((c) => cell(c.row, c.col, c.value))
      : Array.from(Array(size * size), (v, k) => k).map((i) => cell(Math.floor(i / size), i % size))
  })

  obj.serialize = () => {
    return {
      size: state.size,
      cells: state.cells.map((cell) => cell.serialize())
    }
  }

  obj.at = (row, col) => {
    if (row >= 0 && row < state.size && col >= 0 && col < state.size) {
      return state.cells[state.size * row + col]
    }
  }

  obj.neighborCells = (row, col) => {
    const cell = obj.at(row, col)
    if (!cell) {
      return
    }

    let neighbors = []
    ;[-1, 1].forEach((offset) => {
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
      return
    }

    cluster.push(cell)

    const value = cell.value
    obj.neighborCells(row, col).forEach((neighbor) => {
      if (neighbor.is(value) && !cluster.includes(neighbor)) {
        ({ cluster, liberties } = obj.clusterAt(neighbor.row, neighbor.col, { cluster, liberties }))
      } else if (neighbor.is(piece.EMPTY) && !liberties.includes(neighbor)) {
        liberties.push(neighbor)
      }
    })

    return { cluster, liberties }
  }

  obj.DEBUG = () => {
    const range = Array.from(Array(state.size), (v, k) => k)

    let string = ''
    range.forEach((row) => {
      range.forEach((col) => {
        if (obj.at(row, col).is(piece.EMPTY)) {
          string += '-'
        } else if (obj.at(row, col).is(piece.BLACK)) {
          string += 'b'
        } else {
          string += 'w'
        }
      })
      string += '\n'
    })

    console.log(string)
  }

  return obj
}
