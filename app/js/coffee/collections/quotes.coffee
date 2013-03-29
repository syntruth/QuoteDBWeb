class Quotes extends Backbone.Collection
	model: App.Models.Quote
	url:   '/quotes'

window.App.Collections.Quotes = Quotes

