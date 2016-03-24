import should from 'should'

import phase from '../src/game/phase'
import piece from '../src/game/piece'
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
    s.board.DEBUG()
  })

  it.only('it should calculate final score', () => {
    should.exist(s.score)
    s.score.black.should.equal(8)
    s.score.white.should.equal(12.5)
  })
})
