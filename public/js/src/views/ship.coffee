define [
  'views/base'
], (BaseView) ->
  class ShipView extends BaseView
    constructor: (@ctx) ->
      super
      @preset()

    preset: ->
      @ctx.textAlign = 'start'
      @ctx.textBaseline = 'top'
      @ctx.font = '10px sans-serif'

    text: (text, coords, offset = 0, align = 'start', baseline = 'top') ->
      color = @color
      opacity = @opacity
      text_align = @ctx.textAlign
      text_baseline = @ctx.textBaseline

      @applyColor [255, 255, 255], 0.4
      @ctx.textAlign = align
      @ctx.textBaseline = baseline

      @ctx.fillText text, coords[0] + offset, coords[1] + offset

      @applyColor color, opacity
      @ctx.textAlign = text_align
      @ctx.textBaseline = text_baseline
