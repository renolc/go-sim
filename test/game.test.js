import should from 'should'

import game from '../src/game'

describe('game', () => {
  let g

  beforeEach(() => g = game())

  it('should exist', () => should.exist(g))

  it('should have a board', () => g.state.should.property('board').Object())
})