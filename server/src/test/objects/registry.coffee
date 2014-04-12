_ = require 'underscore'
expect = require('chai').expect
Registry = require './../../objects/registry'

class Dummy

describe 'Registry', ->
  it 'Contains an empty collection after initializing', ->
    registry = new Registry Dummy
    expect(registry.all()).to.be.empty

  it 'Creates 1 item of specified type and stores it in the collection', ->
    registry = new Registry Dummy
    item = registry.create()
    collection = _.values(registry.all())
    expect(collection.length).to.equal 1
    expect(item).to.be.instanceof Dummy
    expect(item).to.be.equal collection[0]

  it 'Stores items with ids starting from 1', ->
    registry = new Registry Dummy
    registry.create()
    expect(registry.get(1)).to.exist

  it 'Increments an id for each new item being stored', ->
    registry = new Registry Dummy
    registry.create() for i in [1..10]
    expect(registry.all()).to.have.keys _.map [1..10], (n) -> n.toString()
