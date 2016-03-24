export default (state) => {
  return {
    mark: (row, col) => {
      const { cells } = state.board.clusterAt(row, col)

      cells.forEach((cell) => cell.toggleMark())
    }
  }
}