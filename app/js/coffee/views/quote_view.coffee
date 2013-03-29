class QuoteView extends Backbone.View
	template: () -> $('#quote-template').html()
	
	bindings:
		'.quote':     'quote'
		'.id2':       'id2'
		'.nick':      'nick'
		'.timestamp':
      observe: 'created_at'
      onGet: (v) ->
        d = new Date(v)
        """
        On #{d.getMonth() + 1}-#{d.getDate()}-#{d.getFullYear()} @ #{d.toTimeString()}
        """
		
	render: () ->
    this.$el.html this.template()
    this.stickit()

    return this
	
window.App.Views.QuoteView = QuoteView
