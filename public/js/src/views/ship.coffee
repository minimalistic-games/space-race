define [
  'views/base'
], (BaseView) ->
  class ShipView extends BaseView
    constructor: (@ctx) ->
      super
      @ctx.font = '10px sans-serif'

    text: (text, coords, offset = 0, align = 'start', baseline = 'top') ->
      @applyColor [255, 255, 255], 0.4
      @ctx.textAlign = align
      @ctx.textBaseline = baseline
      @ctx.fillText text, coords[0] + offset, coords[1] + offset
