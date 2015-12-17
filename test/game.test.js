import should from 'should'

import game from '../src/game'
import { piece } from '../src/cell'

describe('game', () => {
  let g

  beforeEach(() => g = game())

  it('should exist', () => should.exist(g))

  it('should have a board', () => g.board.should.Object())

  it('should have a turn which defaults to black', () => g.turn.should.equal(piece.BLACK))

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
  })
})