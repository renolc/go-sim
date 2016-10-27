/* eslint-env mocha */
import should from 'should'

import sim from '../src/game/sim'

describe('end', () => {
  var s

  beforeEach(() => {
    s = sim(4)

    s.play(1, 0)
    s.play(2, 0)
    s.play(1, 1)
    s.play(2, 1)
    s.play(1, 2)
    s.play(2, 2)
    s.play(1, 3)
    s.play(3, 2)

    // dead
    s.play(3, 0)
    s.play(0, 2)

    s.pass()
    s.pass()

    s.mark(3, 0)
    s.propose()
    s.mark(0, 2)
    s.propose()
    s.accept()
  })

  it('should calculate final score', () => {
    should.exist(s.score)
    s.score.black.should.equal(8)
    s.score.white.should.equal(12.5)
  })

  it('should use the set komi', () => {
    const s2 = sim(4)
    s2.komi = 7.5

    s2.pass()
    s2.pass()
    s2.propose()
    s2.accept()

    s2.score.black.should.equal(0)
    s2.score.white.should.equal(7.5)
  })
})
