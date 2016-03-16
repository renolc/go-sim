import { piece } from './cell'
import board from './board'

import { stateProps } from './helpers'

export const phase = Object.freeze({
  PLAY: 'play',
  MARK: 'mark',
  END: 'end'
})

export default ({ size = 9, load } = {}) => {
  if (load) {
    size = 0
  }

  const { state, obj } = stateProps({
    board: board({ size: size }),
    turn: piece.BLACK,
    previousBoard: null,
    phase: phase.PLAY
  })

  if (load) {
    loadState(state, load)
  }

  obj.serialize = () => JSON.parse(JSON.stringify(state))

  obj.load = (load) => {
    loadState(state, load)
  }

  obj.pass = () => {
    if (state.phase !== phase.PLAY) return

    alternateTurns(state)
  }

  obj.play = (row, col) => {
    if (state.phase !== phase.PLAY) return

    const initialState = obj.serialize()
    const initialBoard = JSON.stringify(obj.board.serialize())

    const cell = state.board.at(row, col)
    if (!cell || !cell.is(piece.EMPTY)) return

    cell.set(state.turn)

    // remove captured clusters
    state.board.neighborCells(row, col)
      .filter((c) => {
        return c.is(
            (state.turn === piece.BLACK)
              ? piece.WHITE
              : piece.BLACK
          )
      })
      .forEach((cell) => {
        const { cluster, liberties } = state.board.clusterAt(cell.row, cell.col)
        if (liberties.length === 0) {
          cluster.forEach((cell) => {
            cell.set(piece.EMPTY)
          })
        }
      })

    // if no liberties where we played or new board looks like previous board, invalid move
    const { liberties } = state.board.clusterAt(cell.row, cell.col)
    if (liberties.length === 0 || JSON.stringify(obj.board.serialize()) === obj.previousBoard) {
      return obj.load(initialState)
    }

    obj.previousBoard = initialBoard
    alternateTurns(state)
  }

  return obj
}

function alternateTurns (state) {
  state.turn = (state.turn === piece.BLACK)
    ? piece.WHITE
    : piece.BLACK
}

function loadState (state, load) {
  state.board = board({ load: load.board })
  state.turn = load.turn
  state.previousBoard = load.previousBoard
  state.phase = load.phase
}