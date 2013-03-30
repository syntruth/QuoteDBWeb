class MainView extends Backbone.View
  el: 'body'

  events:
    'click .home-btn':   'reloadHome'
    'click .random-btn': 'getRandom'
    'click .search-btn': 'searchQuotes'
    'click .prev-btn':   'getPrevious'
    'click .next-btn':   'getNext'

    'keypress .term':    'handleKeyPress'
    'slide .limit':      'setNumber'

  initialize: () ->
    @homeBtn = this.$('.home-btn').button
      text: false
      icons:
        primary: 'ui-icon-home'

    @randomBtn = this.$('.random-btn').button
      text: false
      icons:
        primary: 'ui-icon-shuffle'

    @searchBtn = this.$('.search-btn').button
      text: false
      icons:
        primary: 'ui-icon-search'

    @prevBtn = this.$('.prev-btn').button
      text: false
      icons:
        primary: 'ui-icon-circle-triangle-w'

    @nextBtn = this.$('.next-btn').button
      text: false
      icons:
        primary: 'ui-icon-circle-triangle-e'

    @term       = this.$('.term')
    @quotesEl   = this.$('.quotes-list')
    @footer     = this.$('#footer')
    @number     = this.$('.number')
    @page       = 1
    @pageNumber = this.$('.page-number')
    @quotesList = this.$('.quotes-list')

    @limit = this.$('.limit').slider
      min:   1
      max:   20
      value: 20

    this.$el.tooltip()

    if @quotesEl.length
      if window.quotes
        @quotes = new App.Collections.Quotes window.quotes
      else
        @quotes = new App.Collections.Quotes

      @quotesView = new App.Views.QuotesView
        el:    @quotesEl
        model: @quotes

      @quotesView.render()

    @pageOptions = new App.PageOptions
      number:  20
      success: (collection, reply, options) =>
        if reply.length == 0
          @quotes.reset options.previousModels
          @pageOptions.decrPage()

        this.setPageNumber()

    @quotesList.height($(document).height() - 90)

    # We monitor the window's size so we can setup the quotes
    # list height.
    $(window).on 'resize', this.handleResize

  reloadHome: (e) ->
    e.preventDefault()

    @term.val     ''
    @limit.slider 'value', 20
    @number.text  20

    @pageOptions.reset()

    this.showFooter()
    this.loadPage()

  handleKeyPress: (e) ->
    if e.charCode is 13
      @searchBtn.trigger 'click'
      return false
    else
      return true

  loadPage: () -> @quotes.fetch @pageOptions.current()

  getPrevious: (e) ->
    e.preventDefault()

    @pageOptions.decrPage()

    this.loadPage()

  getNext: (e) ->
    e.preventDefault()

    @pageOptions.incrPage()

    this.loadPage()

  searchQuotes: (e) ->
    e.preventDefault()

    @pageOptions.reset()

    @pageOptions.setPage   1
    @pageOptions.setTerm   @term.val()
    @pageOptions.setNumber @number.text()

    this.showFooter()
    this.loadPage()

  getRandom: (e) ->
    e.preventDefault()

    @pageOptions.reset()

    @pageOptions.setRandom()
    @pageOptions.setPage   1
    @pageOptions.setNumber @number.text()

    if @term.val() isnt ''
      @pageOptions.setTerm @term.val()

    this.hideFooter()
    this.loadPage()

  setNumber: (e, ui) ->
    @number.text ui.value
    @pageOptions.setNumber ui.value

  setPageNumber: () ->
    @pageNumber.text @pageOptions.page

  hideFooter: () -> @footer.hide 'slide', direction: 'down'
  showFooter: () -> @footer.show 'slide', direction: 'down'

  handleResize: (e) =>
    height = $(document).height() - 90
    
    @quotesList.height(height)
    
    console.log 'Got resize event...', height


window.App.Views.MainView = MainView
