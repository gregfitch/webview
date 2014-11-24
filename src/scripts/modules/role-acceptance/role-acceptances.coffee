define (require) ->
  BaseView = require('cs!helpers/backbone/views/base')
  template = require('hbs!./role-acceptance-template')
  RoleAcceptances = require('cs!collections/role-acceptances')
  $ = require('jquery')
  settings = require('settings')
  _ = require('underscore')
  require('less!./role-acceptance')

  AUTHORING = "#{location.protocol}//#{settings.cnxauthoring.host}:#{settings.cnxauthoring.port}"

  return  class RoleAcceptanceView extends BaseView
    template: template
    collection: RoleAcceptances

    events:
      'click .submit': 'acceptOrRejectRoles'


    initialize: () ->
      @listenTo(@collection, 'reset', @render)
      @listenTo(@collection, 'change:hasAcceptedLicense change:hasAccepted', @render)


    onRender: () ->
      @setColor()


    setColor: () ->
      model = @collection.at(0)
      rolesCheckbox = $('.rolesCheckbox')
      roles = _.map model?.get('roles'), (role) -> role
      _.each rolesCheckbox, (check) ->
        requestedRole = $(check).attr('data-requested-role')
        hasAccepted = _.where(roles, {'role' : requestedRole})
        row = $(check).closest('tr')
        if hasAccepted[0].role is requestedRole
          if hasAccepted[0].hasAccepted
            row.addClass('isAccepted')
          else if hasAccepted[0].hasAccepted is false
            row.addClass('isRejected')
          else row.addClass('isPending')


    acceptLicense: (model) ->
      if $('.licenseCheckbox').is(':checked')
        model.set('hasAcceptedLicense', true)
      else
        model.set('hasAcceptedLicense', false)


    acceptOrRejectRoles: () ->
      model = @collection.at(0)
      rolesCheckbox = $('.rolesCheckbox')
      roleRequests= []
      @acceptLicense(model)
      data = {"license": model.get('hasAcceptedLicense'), "roles": roleRequests}
      _.each rolesCheckbox, (role) ->
        requestedRole = $(role).attr('data-requested-role')
        if $(role).is(':checked') and model.get('hasAcceptedLicense')
          model.set('hasAccepted', true)
        else
          model.set('hasAccepted', false)

        roles = {"role": requestedRole, "hasAccepted": model.get('hasAccepted')}
        roleRequests.push(roles)

      @collection.acceptOrReject(data)