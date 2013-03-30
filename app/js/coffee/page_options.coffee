class PageOptions

  constructor: (options={}) ->
    @_origOptions = options
    this._setup()

  _setup: () ->
    options  = @_origOptions
    @page    = if options.page then options.page else 1
    @random  = options.page   or false
    @term    = options.term   or ""
    @number  = options.number or 1

    if $.isFunction options.success
      @success = options.success
    else
      @success = () -> return true

    return this

  incrPage: () ->
    @page += 1

    return @page

  decrPage: () ->
    @page -= 1
    @page  = 1 if @page <= 0

    return @page

  setPage: (page=1) ->
    @page = page
    @page = 1 if @page <= 0

    return @page

  setTerm:   (term="")     -> @term   = term
  setRandom: (random=true) -> @random = random
  setNumber: (number=1)    -> @number = number

  current: () ->
    data =
      page:   @page
      number: @number

    data.random = true  if @random
    data.term   = @term if @term

    options =
      data:    data
      success: @success

    return options

  reset: () ->
    this._setup()
    return true

window.App.PageOptions = PageOptions
