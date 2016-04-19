/* eslint-env mocha */
import should from 'should'

import piece from '../src/game/piece'
import cell from '../src/game/cell'

describe('cell', () => {
  var c

  beforeEach(() => {
    c = cell({
      row: 2,
      col: 3
    })
  })

  it('should exists', () => should.exist(c))

  it('should default to empty', () => c.value.should.equal(piece.EMPTY))

  describe('is', () => {
    it('should return true when values match', () => c.is(piece.EMPTY).should.be.true())

    it('should return false when values do not match', () => {
      c.is(piece.BLACK).should.be.false()
      c.is(piece.WHITE).should.be.false()
    })
  })

  describe('set', () => {
    it('should change the value', () => {
      c.is(piece.EMPTY).should.be.true()
      c.set(piece.BLACK)
      c.is(piece.BLACK).should.be.true()
    })
  })
})
