import piece from './piece'
import cell from './cell'

import range from '../helpers/range'

export default (...args) => {
  var size = 9
  var state

  const arg = args[0]

  switch(typeof arg) {

    // load board state
    case 'object':
      state = {...arg}
      state.cells = state.cells.map((c) => cell({...c}))
      break

    // set board size and fall through into default
    case 'number':
      size = arg

    // everything else
    default:
      state = {
        size,
        cells: range(size * size).map((i) => cell({
            row: Math.floor(i / size),
            col: i % size
        }))
      }
  }

  state.at = (row, col) => {
    if (row >= 0 && row < state.size && col >= 0 && col < state.size) {
      return state.cells[state.size * row + col]
    }
  }

  state.neighborCells = (row, col) => {
    const cell = state.at(row, col)
    if (!cell) {
      return
    }

    let neighbors = []
    ;[-1, 1].forEach((offset) => {
      const dr = row + offset
      const dc = col + offset

      const vertical = state.at(dr, col)
      const horizontal = state.at(row, dc)

      if (vertical) {
        neighbors.push(vertical)
      }
      if (horizontal) {
        neighbors.push(horizontal)
      }
    })

    return neighbors
  }

  state.clusterAt = (row, col, { cluster = [], liberties = [] } = {}) => {
    const cell = state.at(row, col)
    if (!cell) {
      return
    }

    cluster.push(cell)

    const value = cell.value
    state.neighborCells(row, col).forEach((neighbor) => {
      if (neighbor.is(value) && !cluster.includes(neighbor)) {
        ({ cluster, liberties } = state.clusterAt(neighbor.row, neighbor.col, { cluster, liberties }))
      } else if (neighbor.is(piece.EMPTY) && !liberties.includes(neighbor)) {
        liberties.push(neighbor)
      }
    })

    return { cluster, liberties }
  }

  state.DEBUG = () => {
    const r = range(state.size)

    let string = ''
    r.forEach((row) => {
      r.forEach((col) => {
        if (state.at(row, col).is(piece.WHITE)) {
          string += 'w'
        } else if (state.at(row, col).is(piece.BLACK)) {
          string += 'b'
        } else {
          string += '-'
        }
      })
      string += '\n'
    })

    console.log(string)
  }

  return state
}
