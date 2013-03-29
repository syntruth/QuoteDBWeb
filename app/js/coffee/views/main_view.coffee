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

    @footer     = this.$('#footer')
    @number     = this.$('.number')
    @page       = 1
    @pageNumber = this.$('.page-number')

    @limit = this.$('.limit').slider
      min: 1
      max: 20

    @term = this.$('.term')

    this.$el.tooltip()

    @quotesEl = this.$('.quotes-list')

    if @quotesEl.length
      if window.quotes
        @quotes = new App.Collections.Quotes window.quotes
      else
        @quotes = new App.Collections.Quotes

      @quotesView = new App.Views.QuotesView
        el:    @quotesEl
        model: @quotes

      @quotesView.render()

  reloadHome: (e) ->
    e.preventDefault()

    @page = 1

    this.loadPage()

  handleKeyPress: (e) ->
    if e.charCode is 13
      @searchBtn.focus()
      @searchBtn.trigger 'click'
      return false
    else
      return true

  loadPage: () ->
    @quotes.fetch
      data:
        page: @page
      success: (collection, reply, options) =>
        if reply.length == 0
          @quotes.reset options.previousModels
          @page--

        this.setPageNumber()

  getPrevious: (e) ->
    e.preventDefault()

    @page--

    if @page <= 0
      @page = 1
    else
      this.loadPage()

  getNext: (e) ->
    e.preventDefault()

    @page++

    this.loadPage()

  searchQuotes: (e) ->
    e.preventDefault()

    @quotes.fetch
      data:
        term:   @term.val()
        number: @number.text()
      success: () =>
        @page = 1
        this.setPageNumber()

  getRandom: (e) ->
    e.preventDefault()

    data =
      random: true
      number: @number.text()

    if @term.val() isnt ''
      data.term = @term.val()

    @quotes.fetch
      data: data
      success: () =>
        @page = 1
        this.setPageNumber()

  setNumber: (e, ui) ->
    @number.text ui.value

  setPageNumber: () ->
    @pageNumber.text @page

window.App.Views.MainView = MainView
