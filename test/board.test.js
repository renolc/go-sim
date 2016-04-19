/* eslint-env mocha */
import should from 'should'

import piece from '../src/game/piece'
import board from '../src/game/board'

describe('board', () => {
  var b

  beforeEach(() => {
    b = board()
  })

  it('should exist', () => should.exist(b))

  it('should default size to 9', () => b.size.should.equal(9))

  it('should set size to passed in number', () => board(2).size.should.equal(2))

  describe('at', () => {
    it('should return cell at position', () => b.at(2, 3).should.equal(b.cells[21]))

    it('should return undefined for invalid position', () => {
      should.not.exist(b.at(-1, 0))
      should.not.exist(b.at(0, -1))
      should.not.exist(b.at(b.size, 0))
      should.not.exist(b.at(0, b.size))
    })
  })

  describe('neighborCells', () => {
    it('should return all cells around position', () => {
      const neighbors = b.neighborCells(1, 1)

      neighbors.length.should.equal(4)
      neighbors.should.containEql(b.at(1, 0))
      neighbors.should.containEql(b.at(1, 2))
      neighbors.should.containEql(b.at(0, 1))
      neighbors.should.containEql(b.at(2, 1))
    })
  })

  describe('clusterAt', () => {
    var cluster

    beforeEach(() => {
      b.at(0, 0).set(piece.BLACK)
      b.at(0, 1).set(piece.BLACK)
      b.at(1, 1).set(piece.BLACK)
      b.at(1, 0).set(piece.WHITE)
      b.at(2, 2).set(piece.WHITE)
      b.at(2, 0).set(piece.BLACK)

      cluster = b.clusterAt(0, 0)
    })

    it('should return all pieces in cluster', () => {
      cluster.cells.length.should.equal(3)
      cluster.cells.should.containEql(b.at(0, 0))
      cluster.cells.should.containEql(b.at(0, 1))
      cluster.cells.should.containEql(b.at(1, 1))
    })

    it('should return liberties for cluster', () => {
      cluster.liberties.length.should.equal(3)
      cluster.liberties.should.containEql(b.at(0, 2))
      cluster.liberties.should.containEql(b.at(1, 2))
      cluster.liberties.should.containEql(b.at(2, 1))
    })
  })
})
