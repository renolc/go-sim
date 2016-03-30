import piece from '../game/piece'
import range from '../helpers/range'

export default (state) => {
  const komi = 6.5

  var score = {
    black: 0,
    white: komi
  }

  var visited = []
  range(state.board.size).forEach((row) => {
    range(state.board.size).forEach((col) => {
      if (visited.includes(state.board.at(row, col))) return

      const cluster = state.board.clusterAt(row, col)
      cluster.cells.forEach((cell) => {
        if (!cell.is(piece.EMPTY)) {
          score[cell.value]++
        } else if (cluster.touched.length === 1) {
          score[cluster.touched[0]]++
        }
        visited.push(cell)
      })
    })
  })

  return {
    score
  }
}