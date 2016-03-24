import piece from '../game/piece'

export default (state) => {
  const komi = 6.5

  var score = {
    black: 0,
    white: komi
  }

  var visited = []
  for(var row = 0; row < state.board.size; row++) {
    for(var col = 0; col < state.board.size; col++) {
      if (visited.includes(state.board.at(row, col))) continue

      const cluster = state.board.clusterAt(row, col)
      cluster.cells.forEach((cell) => {
        if (!cell.is(piece.EMPTY)) {
          score[cell.value]++
        } else if (cluster.touched.length === 1) {
          score[cluster.touched[0]]++
        }
        visited.push(cell)
      })

    }
  }

  return {
    score
  }
}