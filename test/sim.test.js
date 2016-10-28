/* eslint-env mocha */
import should from 'should'

import piece from '../src/game/piece'
import phase from '../src/game/phase'
import sim from '../src/game/sim'

describe('sim', () => {
  var s

  beforeEach(() => {
    s = sim()
  })

  it('should exist', () => should.exist(s))

  it('should default turn to black', () => s.turn.should.equal(piece.BLACK))

  it('should default phase to play', () => s.phase.should.equal(phase.PLAY))

  it('should default komi to 6.5', () => s.komi.should.equal(6.5))

  it('should load another state', () => {
    const orig = s.serialize()
    s.serialize().should.eql(orig)

    s.board.at(0, 0).set(piece.BLACK)
    s.turn = piece.WHITE

    s.serialize().should.not.eql(orig)
    s = sim(orig)
    s.serialize().should.eql(orig)
  })

  it('should load with phase specific functions', () => {
    s.pass()
    s.pass()
    const state = s.serialize()

    const s2 = sim()
    s2.load(state)
    should.not.exist(s2.play)
    should.exist(s2.mark)

    const s3 = sim(state)
    should.not.exist(s3.play)
    should.exist(s3.mark)
  })

  it('should persist komi', () => {
    s.komi = 7.5
    const state = s.serialize()

    const s2 = sim(state)
    s2.komi.should.equal(7.5)
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
