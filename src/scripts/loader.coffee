define [
  'jquery'
  'underscore'
  'backbone'
  'cs!router'
], ($, _, Backbone, router) ->

  root = '/'

  init = () ->
    external = new RegExp('^((f|ht)tps?:)?//')

    # Catch internal application links and let Backbone handle the routing
    $(document).on 'click', 'a:not([data-bypass])', (e) ->
      href = $(this).attr('href')

      # Don't handle navigation if the default handling was already prevented
      if e.isDefaultPrevented() then return

      e.preventDefault()

      if external.test(href)
        window.open(href, '_blank')
      else
        router.navigate(href, {trigger: true})

    Backbone.history.start
      pushState: true
      root: root

    $.ajaxPrefilter ( options, originalOptions, jqXHR ) ->
      if not external.test(options.url)
        options.url = root + options.url

      return

  return {init: init}
