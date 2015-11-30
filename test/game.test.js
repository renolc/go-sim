import should from 'should'

import game from '../src/game'
import { piece } from '../src/cell'

describe('game', () => {
  let g

  beforeEach(() => g = game())

  it('should exist', () => should.exist(g))

  it('should have a board', () => g.state.should.property('board').Object())

  it('should have a turn which defaults to black', () => g.state.should.property('turn', piece.BLACK))
})