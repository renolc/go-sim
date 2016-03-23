import piece from '../game/piece'

export default (state) => {
  state.turn = (state.turn === piece.BLACK)
    ? piece.WHITE
    : piece.BLACK
}