import should from 'should'

import phase from '../src/game/phase'
import piece from '../src/game/piece'
import sim from '../src/game/sim'

describe('mark', () => {
  var s

  beforeEach(() => {
    s = sim(4)

    s.play(0, 0)
    s.play(0, 1)
    s.play(0, 2)
    s.play(1, 0)
    s.play(1, 1)
    s.play(2, 0)
    s.play(0, 0)
    s.play(3, 1)
    s.play(1, 2)
    s.play(3, 2)

    s.pass()
    s.pass()
  })

  describe('mark', () => {
    it('should toggle mark cell', () => {
      s.board.at(0, 0).marked.should.be.false()
      s.mark(0, 0)
      s.board.at(0, 0).marked.should.be.true()
      s.mark(0, 0)
      s.board.at(0, 0).marked.should.be.false()
    })

    it('should not mark empty cells', () => {
      s.board.at(0, 1).marked.should.be.false()
      s.mark(0, 1)
      s.board.at(0, 1).marked.should.be.false()
    })

    it('should not do anything on invalid position', () => {
      const orig = s.serialize()

      s.mark(-1, 0)
      s.mark(0, -1)
      s.mark(s.board.size, 0)
      s.mark(0, s.board.size)

      s.serialize().should.eql(orig)
    })

    it('should toggle mark all cells in cluster', () => {
      const { cells } = s.board.clusterAt(0, 2)

      cells.forEach((cell) => cell.marked.should.be.false())
      s.mark(0, 2)
      cells.forEach((cell) => cell.marked.should.be.true())
      s.mark(0, 2)
      cells.forEach((cell) => cell.marked.should.be.false())
    })
  })

  describe('propose', () => {
    it('should alternate turns', () => {
      s.turn.should.equal(piece.BLACK)
      s.propose()
      s.turn.should.equal(piece.WHITE)
      s.propose()
      s.turn.should.equal(piece.BLACK)
    })
  })

  describe('accept', () => {
    it('should change to end phase', () => {
      s.phase.should.equal(phase.MARK)
      s.accept()
      s.phase.should.equal(phase.END)
    })

    it('should remove all marked cells', () => {
      const cluster = s.board.clusterAt(0, 2)

      s.mark(0, 2)
      s.accept()

      cluster.cells.forEach((cell) => {
        cell.marked.should.be.false()
        cell.is(piece.EMPTY).should.be.true()
      })
    })
  })

  describe('reject', () => {
    it('should change to play phase', () => {
      s.phase.should.equal(phase.MARK)
      s.reject()
      s.phase.should.equal(phase.PLAY)
    })

    it('should set all marks to false', () => {
      const cluster = s.board.clusterAt(0, 2)

      s.mark(0, 2)
      s.reject()

      cluster.cells.forEach((cell) => {
        cell.marked.should.be.false()
      })
    })
  })
})