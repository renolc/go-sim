import should from 'should'

import board from '../src/board'
import { piece } from '../src/cell'
import _ from 'underscore'

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

  describe('clusterAt', () => {
    let cluster

    beforeEach(() => {
      b.at(0, 0).set(piece.BLACK)
      b.at(1, 0).set(piece.WHITE)
      b.at(0, 1).set(piece.BLACK)
      b.at(1, 1).set(piece.BLACK)
      b.at(1, 2).set(piece.BLACK)
      b.at(2, 3).set(piece.BLACK)
      cluster = _.map(b.clusterAt(0, 0), (cell) => cell.serialize())
    })

    it('should contain all connected cells of like value', () => {
      cluster.length.should.equal(4)
      cluster.should.containEql(b.at(0, 0).serialize())
      cluster.should.containEql(b.at(0, 1).serialize())
      cluster.should.containEql(b.at(1, 1).serialize())
      cluster.should.containEql(b.at(1, 2).serialize())
    })

    it('should not contain unconnected diagonal cells', () => cluster.should.not.containEql(b.at(2, 3).serialize()))

    it('should not contain connected cells of diff value', () => cluster.should.not.containEql(b.at(1, 0).serialize()))
  })
})