import should from 'should'

import piece from '../src/game/piece'
import phase from '../src/game/phase'
import sim from '../src/game/sim'

describe('sim', () => {
  var s

  beforeEach(() => s = sim(1))

  it('should exist', () => should.exist(s))

  it('should default turn to black', () => s.turn.should.equal(piece.BLACK))

  it('should default phase to play', () => s.phase.should.equal(phase.PLAY))

  it('should load another state', () => {
    const orig = s.serialize()
    s.serialize().should.eql(orig)

    s.board.at(0, 0).set(piece.BLACK)
    s.turn = piece.WHITE

    s.serialize().should.not.eql(orig)
    s = sim(orig)
    s.serialize().should.eql(orig)
  })

  describe('serialize', () => {
    it('should return a plain JS object of state', () => {
      const serialized = s.serialize()
      const props = Object.getOwnPropertyNames(serialized)

      props.should.not.containEql('serialize')
      props.should.not.containEql('load')
    })
  })
})