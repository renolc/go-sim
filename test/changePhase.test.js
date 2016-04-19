/* eslint-env mocha */
import should from 'should'

import sim from '../src/game/sim'
import phase from '../src/game/phase'
import changePhase from '../src/helpers/changePhase'

describe('changePhase', () => {
  var s

  beforeEach(() => {
    s = sim(1)
  })

  it('should only have play methods', () => {
    should.exist(s.pass)
    should.exist(s.play)
    should.not.exist(s.mark)
    should.not.exist(s.propose)
    should.not.exist(s.accept)
    should.not.exist(s.reject)
    should.not.exist(s.score)
  })

  it('should only have mark methods', () => {
    changePhase(s, phase.MARK)

    should.not.exist(s.pass)
    should.not.exist(s.play)
    should.exist(s.mark)
    should.exist(s.propose)
    should.exist(s.accept)
    should.exist(s.reject)
    should.not.exist(s.score)
  })

  it('should only have end score', () => {
    changePhase(s, phase.END)

    should.not.exist(s.pass)
    should.not.exist(s.play)
    should.not.exist(s.mark)
    should.not.exist(s.propose)
    should.not.exist(s.accept)
    should.not.exist(s.reject)
    should.exist(s.score)
  })
})
