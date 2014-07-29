_ = require 'underscore'
expect = require('chai').expect
Ship = require './../../objects/ship'

describe 'Ship', ->
  it 'After initialization: has an id, coords, no blocks and is active', ->
    ship = new Ship 1
    expect(ship.id).to.be.equal 1
    expect(ship.coords).not.to.be.empty
    expect(ship.blocks).to.be.empty
    expect(ship.is_active).to.be.true

  it 'Generates proper blocks', ->
    ship = new Ship

    _.times 10, (level) ->
      ship.generateBlocks level

      expect(ship.blocks.length).to.be.most Math.pow((2 * level + 1), 2) - 1

      _.each ship.blocks, (normalized_coords) ->
        _.each normalized_coords, (normalized_coord) ->
          expect(Math.abs normalized_coord).to.be.most level
