import should from 'should'

import cell, { piece } from '../src/cell'

describe('cell', () => {
  let c

  beforeEach(() => c = cell(2, 3))

  it('should exist', () => should.exist(c))

  it('should have the set row and col', () => {
    c.row.should.equal(2)
    c.col.should.equal(3)
  })

  it('should default to empty', () => c.value.should.equal(piece.EMPTY))

  describe('is', () => {
    it('should return true when values match', () => c.is(piece.EMPTY).should.ok())

    it('should return false when values do not match', () => c.is(piece.BLACK).should.not.ok())
  })
})
