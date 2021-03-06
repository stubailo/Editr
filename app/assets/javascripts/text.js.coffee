unless window.text
  window.text = {}

  window.text.wrapping_texts = []

  class window.text.WrappingText extends window.sel.Deleteable
    
    constructor: (@element) ->

      @element.addClass "wrapping_text"

      @content = $ "<div></div>"

      @content.html @element.html()
      @element.html ""
      @element.append @content

      @content.attr "contenteditable", "true"

      @drag_handle = $ "<div></div>"
      @drag_handle.text "drag to reorder"
      @drag_handle.addClass "handle text-drag-handle"
      @element.append @drag_handle

      @drag_handle.hide()

      super(@element)

      window.text.wrapping_texts.push(this)

      @prev_height = @element.height()

      @content.bind "DOMCharacterDataModified", =>
        if @element.height() isnt @prev_height
          @element.trigger "resize"
          @prev_height = @element.height()

    delete: =>
      super()
      window.text.wrapping_texts = (text for text in window.text.wrapping_texts when text isnt this)

    select: =>
      super()
      @drag_handle.show()

    deselect: =>
      super()
      @drag_handle.hide()
      @content.blur()
