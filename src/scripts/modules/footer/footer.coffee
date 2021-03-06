define (require) ->
  settings = require('settings')
  BaseView = require('cs!helpers/backbone/views/base')
  template = require('hbs!./footer-template')
  socialMedia = require('cs!helpers/socialmedia')
  linksHelper = require('cs!helpers/links')
  require('less!./footer')

  return class FooterView extends BaseView
    template: template
    templateHelpers: () ->
      locationOrigin = linksHelper.locationOrigin()

      return {
        share: socialMedia.socialMediaInfo('','An OpenStax CNX book',locationOrigin)
        legacy: settings.legacy
        url: locationOrigin + settings.root
        webmaster: settings.webmaster
      }

    onRender: () ->
      height = @$el.find('.copyright').height()
      @$el.find('.connect').height(height)
      @$el.find('.share').height(height)
