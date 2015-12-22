import should from 'should'

import game from '../src/game'
import { piece } from '../src/cell'

describe('game', () => {
  let g

  beforeEach(() => g = game())

  it('should exist', () => should.exist(g))

  it('should have a board', () => g.board.should.Object())

  it('should have a turn which defaults to black', () => g.turn.should.equal(piece.BLACK))

  describe('load', () => {
    let g2

    beforeEach(() => {
      g.play(2, 3)
      g.play(4, 5)
      g.pass()
      g2 = game({ load: g.serialize() })
    })

    it('should load the game state', () => g2.serialize().should.equal(g.serialize()))
  })

  describe('pass', () => {
    beforeEach(() => g.pass())

    it('should alternate turns', () => {
      g.turn.should.equal(piece.WHITE)
      g.pass()
      g.turn.should.equal(piece.BLACK)
    })
  })

  describe('play', () => {
    let turn

    beforeEach(() => {
      turn = g.turn
      g.play(2, 3)
    })

    it('should alternate turns', () => {
      g.turn.should.equal(piece.WHITE)
      g.play(3, 4)
      g.turn.should.equal(piece.BLACK)
    })

    it('should set the value of cell at pos to current turn', () => g.board.at(2, 3).is(turn).should.ok())

    it('should not change anything on invalid pos', () => {
      const orig = g.serialize()
      g.play(-1, 2)
      g.serialize().should.equal(orig)
      g.play(2, -1)
      g.serialize().should.equal(orig)
      g.play(10, 2)
      g.serialize().should.equal(orig)
      g.play(2, 10)
      g.serialize().should.equal(orig)
    })

    it('should not change anything when playing on non empty cell', () => {
      const orig = g.serialize()
      g.play(2, 3)
      g.serialize().should.equal(orig)
    })

    it('should remove surrounded cell', () => {
      g.board.at(1, 3).set(piece.WHITE)
      g.board.at(3, 3).set(piece.WHITE)
      g.board.at(2, 2).set(piece.WHITE)
      g.play(2, 4)

      g.board.at(2, 3).value.should.equal(piece.EMPTY)
    })

    it('should remove surrounded cluster', () => {
      g.board.at(1, 3).set(piece.BLACK)
      g.board.at(2, 4).set(piece.BLACK)

      g.board.at(1, 2).set(piece.WHITE)
      g.board.at(2, 2).set(piece.WHITE)
      g.board.at(3, 3).set(piece.WHITE)
      g.board.at(3, 4).set(piece.WHITE)
      g.board.at(2, 5).set(piece.WHITE)
      g.board.at(1, 4).set(piece.WHITE)
      g.play(0, 3)

      g.board.at(1, 3).value.should.equal(piece.EMPTY)
      g.board.at(2, 3).value.should.equal(piece.EMPTY)
      g.board.at(2, 4).value.should.equal(piece.EMPTY)
    })

    it('should not change anything when playing where no liberties', () => {
      g.board.at(2, 5).set(piece.BLACK)
      g.board.at(1, 4).set(piece.BLACK)
      g.board.at(3, 4).set(piece.BLACK)
      const orig = g.serialize()
      g.play(2, 4)
      g.serialize().should.equal(orig)
    })

    it('should play where no liberties, if it also captures', () => {
      g.board.at(2, 5).set(piece.BLACK)
      g.board.at(1, 4).set(piece.BLACK)
      g.board.at(3, 4).set(piece.BLACK)

      g.board.at(1, 3).set(piece.WHITE)
      g.board.at(2, 2).set(piece.WHITE)
      g.board.at(3, 3).set(piece.WHITE)
      g.play(2, 4)

      g.board.at(2, 3).value.should.equal(piece.EMPTY)
      g.board.at(2, 4).value.should.equal(piece.WHITE)
      g.turn.should.equal(piece.BLACK)
    })
  })
})
