import should from 'should'

import piece from '../src/game/piece'
import phase from '../src/game/phase'
import sim from '../src/game/sim'

describe('play', () => {
  var s

  beforeEach(() => s = sim(4))

  describe('pass', () => {
    it('should alternate turns', () => {
      s.turn.should.equal(piece.BLACK)
      s.pass()
      s.turn.should.equal(piece.WHITE)
      s.pass()
      s.turn.should.equal(piece.BLACK)
    })

    it('should set the previous play', () => {
      s.previousPlay.should.be.empty()
      s.pass()
      s.previousPlay.should.eql({
        turn: piece.BLACK,
        type: 'pass'
      })
    })

    it('should transition to mark phase after consecutive passes', () => {
      s.phase.should.equal(phase.PLAY)
      s.pass()
      s.phase.should.equal(phase.PLAY)
      s.pass()
      s.phase.should.equal(phase.MARK)
    })
  })

  describe('play', () => {
    it('should alternate turns', () => {
      s.turn.should.equal(piece.BLACK)
      s.play(0, 0)
      s.turn.should.equal(piece.WHITE)
      s.play(0, 1)
      s.turn.should.equal(piece.BLACK)
    })

    it('should set value of cell', () => {
      s.board.at(0, 0).is(piece.EMPTY).should.be.true()
      s.play(0, 0)
      s.board.at(0, 0).is(piece.BLACK).should.be.true()

      s.board.at(0, 1).is(piece.EMPTY).should.be.true()
      s.play(0, 1)
      s.board.at(0, 1).is(piece.WHITE).should.be.true()
    })

    it('should set the previous play', () => {
      s.previousPlay.should.be.empty()
      s.play(1, 2)
      s.previousPlay.should.eql({
        turn: piece.BLACK,
        type: 'play',
        position: [1, 2]
      })
    })

    describe('invalid', () => {
      it('should not change when played on invalid position', () => {
        s.play(0, 0)
        const orig = s.serialize()

        s.play(-1, 0)
        s.serialize().should.eql(orig)

        s.play(0, -1)
        s.serialize().should.eql(orig)

        s.play(s.board.size, 0)
        s.serialize().should.eql(orig)

        s.play(0, s.board.size)
        s.serialize().should.eql(orig)
      })

      it('should not change when played on non empty cell', () => {
        s.play(0, 0)
        const orig = s.serialize()
        s.play(0, 0)
        s.serialize().should.eql(orig)
      })

      it('should not change when played where no liberties', () => {
        s.board.at(0, 1).set(piece.WHITE)
        s.board.at(1, 0).set(piece.WHITE)
        s.board.at(1, 2).set(piece.WHITE)
        s.board.at(2, 1).set(piece.WHITE)
        const orig = s.serialize()

        s.play(1, 1)
        s.serialize().should.eql(orig)
      })

      it('should not change when ko', () => {
        s.board.at(0, 1).set(piece.WHITE)
        s.board.at(1, 0).set(piece.WHITE)
        s.board.at(2, 1).set(piece.WHITE)
        s.board.at(1, 2).set(piece.WHITE)

        s.board.at(0, 2).set(piece.BLACK)
        s.board.at(2, 2).set(piece.BLACK)
        s.board.at(1, 3).set(piece.BLACK)

        s.play(1, 1)
        const orig = s.serialize()

        s.play(1, 2)
        s.serialize().should.eql(orig)
      })
    })

    describe('capture', () => {
      it('should remove surrounded piece', () => {
        s.board.at(1, 1).set(piece.WHITE)
        s.board.at(0, 1).set(piece.BLACK)
        s.board.at(1, 0).set(piece.BLACK)
        s.board.at(2, 1).set(piece.BLACK)

        s.play(1, 2)
        s.board.at(1, 1).is(piece.EMPTY).should.be.true()
      })

      it('should remove surrounded cluster', () => {
        s.board.at(0, 0).set(piece.WHITE)
        s.board.at(0, 1).set(piece.WHITE)
        s.board.at(1, 0).set(piece.WHITE)
        s.board.at(2, 0).set(piece.BLACK)
        s.board.at(1, 1).set(piece.BLACK)

        s.play(0, 2)
        s.board.at(0, 0).is(piece.EMPTY).should.be.true()
        s.board.at(0, 1).is(piece.EMPTY).should.be.true()
        s.board.at(1, 0).is(piece.EMPTY).should.be.true()
      })
    })
  })
})