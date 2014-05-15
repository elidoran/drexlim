class Ncbi
  constructor: ->
    @root = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/'
    @esearch = 'esearch.fcgi?'
    @efetch = 'efetch.fcgi?'
    
  search: (options, callback) ->
    console.log 'search'
    # TODO: validate the options
    call = 
      params:
        db: if options?.db? then options.db else 'gene'
        term: options.term
        retmode: if options?.format? then options.format else 'json'
    
    call.params.term += " AND #{options.filter}[filter]" if options?.filter?
    call.timeout = options.timeout if options?.timeout?
    
    pairs = ("#{key} = #{val}" for key,val of options)
    pairs.push "#{key} = #{val}" for key,val of call.params
    #console.log "pairs: #{pairs}"
    @_call @root + @esearch, call, callback

  fetch: (options, callback) ->
    console.log 'fetch'
    # TODO: validate the options
    call = 
      params:
        db: if options?.db? then options.db else 'nucleotide'
        id: options.id
        rettype: if options?.format? then options.format else 'fasta'
    
    call.timeout = options.timeout if options?.timeout?
    
    @_call @root + @efetch, call, callback

  _call: (path, call, callback) ->
    pairs = ("#{key} = #{val}" for key,val of call)
    #console.log "call [#{path}] [#{call}]"
    HTTP.get path, call, (error, result) ->
      # TODO: if error is a timeout, try the call again, just in case..
      unless error
        #pairs = ("#{key} = #{val}" for key,val of result)
        ##pairs.push "#{key} = #{val}" for key,val of call.params
        #console.log "result pairs: #{pairs}"
        # result is json? would be in result.data instead of result.content
        # just return result? or extract it out if successful
        result = if result?.data? then result.data else result.content
      
      callback error, result if callback?
    
  # can build a function to use repeatedly passing only the specific info for
  # that call, like, the search term, or the ID to get DNA for.
  #buildSearch: () ->
  #  # geneSearch = Ncbi.buildSearch()
  #  #  .db 'gene'
  #  #  .format 'json'
  #  #  .term 'slr'
  #  #  .filter 'bacteria'
  #  #  .error errorCallback
  #  #  .result resultCallback

NCBI = new Ncbi()

