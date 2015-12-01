import should from 'should'

import board from '../src/board'

describe('board', () => {
  let b

  beforeEach(() => b = board())

  it('should exist', () => should.exist(b))

  it('should have a size', () => b.get('size').should.equal(9))

  it('should have an array of cells', () => b.get('cells').should.Array())

  it('should have cell array of length size*size', () => b.get('cells').length.should.equal(9*9))

  describe('at', () => {
    it('should get the cell at position', () => {
      const cell = b.at(3, 4)
      cell.get('row').should.equal(3)
      cell.get('col').should.equal(4)
    })

    it('should return undefined when invalid position', () => {
      should.not.exist(b.at(-1, 2))
      should.not.exist(b.at(2, -1))
      should.not.exist(b.at(2, 10))
      should.not.exist(b.at(10, 2))
    })
  })
})