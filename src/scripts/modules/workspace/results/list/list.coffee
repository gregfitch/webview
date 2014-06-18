define (require) ->
  settings = require('settings')
  BaseView = require('cs!helpers/backbone/views/base')
  template = require('hbs!./list-template')
  require('less!./list')

  AUTHORING = "#{location.protocol}//#{settings.cnxauthoring.host}:#{settings.cnxauthoring.port}"

  return class SearchResultsListView extends BaseView
    template: template
    templateHelpers: () ->
      results = @model.get('results').items

      books = _.where(results, {mediaType: 'Collection'})
      pages = _.where(results, {mediaType: 'Module'})
      misc = _.filter(results, (result) -> result.mediaType isnt 'Collection' and result.mediaType isnt 'Module')

      return {books: books, pages: pages, misc: misc}

    events:
      'click td.delete': 'clickDelete'

    clickDelete: (e) ->
      version = $(e.currentTarget).parent().data('id')
      @deleteMedia(version)

    deleteMedia: (version) ->
      # maybe make each item its own view and use a delete method on the model?
      # FIX: Remove `.json` from URL
      # FIX: Look into making each list item its own view, remove data-id
      #      from template, and make its model the individual item.
      #       Probably dependent on search-results being made into a collection
      # FIX: Move delete function into node.coffee (@model.destroy())
      $.ajax
        url: "#{AUTHORING}/contents/#{version}.json"
        type: 'DELETE'
      .done (response) =>
        @model.fetch()
      .fail (error) =>
        alert("#{error.status}: #{error.statusText}")
