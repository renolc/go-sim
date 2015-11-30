import should from 'should'

import game from '../src/game'
import { piece } from '../src/cell'

describe('game', () => {
  let g

  beforeEach(() => g = game())

  it('should exist', () => should.exist(g))

  it('should have a board', () => g.state.should.property('board').Object())

  it('should have a turn which defaults to black', () => g.state.should.property('turn', piece.BLACK))

  describe('pass', () => {
    beforeEach(() => g.pass())

    it('should alternate turns', () => {
      g.state.turn.should.equal(piece.WHITE)
      g.pass()
      g.state.turn.should.equal(piece.BLACK)
    })
  })

  describe('play', () => {
    let turn

    beforeEach(() => {
      turn = g.state.turn
      g.play(2, 3)
    })

    it('should alternate turns', () => {
      g.state.turn.should.equal(piece.WHITE)
      g.play(3, 4)
      g.state.turn.should.equal(piece.BLACK)
    })

    it('should set the value of cell at pos to current turn', () => g.state.board.at(2, 3).is(turn).should.ok())

    it('should not change anything on invalid pos', () => {
      const orig = {...g.state}
      g.play(-1, 2)
      g.state.should.deepEqual(orig)
      g.play(2, -1)
      g.state.should.deepEqual(orig)
      g.play(10, 2)
      g.state.should.deepEqual(orig)
      g.play(2, 10)
      g.state.should.deepEqual(orig)
    })

    it('should not change anything when playing on non empty cell', () => {
      const orig = {...g.state}
      g.play(2, 3)
      g.state.should.deepEqual(orig)
    })
  })
})