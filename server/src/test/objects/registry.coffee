_ = require 'underscore'
expect = require('chai').expect
Registry = require './../../objects/registry'

class Dummy

describe 'Registry', ->
  it 'Contains an empty collection after initializing', ->
    registry = new Registry Dummy
    expect(registry.all()).to.be.empty

  it 'Stores items with ids starting from 0', ->
    registry = new Registry Dummy
    registry.create()
    expect(registry.get 0).to.exist

  it 'Creates 1 item of specified type and stores it in the collection', ->
    registry = new Registry Dummy
    item = registry.create()
    collection = registry.all()
    expect(_.size collection).to.equal 1
    expect(item).to.be.instanceof Dummy
    expect(item).to.be.equal registry.get 0

  it 'Increments an id for each new item being stored', ->
    registry = new Registry Dummy
    registry.create() for i in [0..9]
    expect(registry.all()).to.have.keys _.map [0..9], (n) -> n.toString()

  it 'Removes an item from the collection', ->
    registry = new Registry Dummy
    registry.create()
    registry.remove 0
    expect(registry.get 0).to.be.undefined
