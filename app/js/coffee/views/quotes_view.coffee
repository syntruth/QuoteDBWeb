class QuotesView extends Backbone.View
  template: () -> $('#quotes-list-template').html()

  initialize: () ->
    this.listenTo @model, 'all',   this.addAll
    this.listenTo @model, 'add',   this.addOne
    this.listenTo @model, 'reset', this.addAll

    return this

  render: () ->
    this.$el.html this.template()
    
    @list = this.$('.list')

    this.addAll() if @model.length > 0

    return this

  addOne: (quote) ->
    view = new App.Views.QuoteView model: quote

    @list.append view.render().$el

  addAll: () ->
    @list.html ''

    @model.each (quote) =>
      this.addOne quote

window.App.Views.QuotesView = QuotesView
    
