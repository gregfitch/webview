(function () {
  'use strict';

  define(function () {
    return function (settings, _, $, callback) {
      require(['settings/concept-coach-enabled-config'], function (makeCoachEnabledConfig) {

        // config per feature as needed. The key should match the feature string in
        // the features' array, and then you can modify the config for either
        // `enable`d or 'disable'd features.
        var features = {
          conceptCoach: {
            enable: makeCoachEnabledConfig(settings, _, $)
          }
        };

        function handleOptions(options) {
          if (_.isFunction(options)) {
            return options;
          } else if (_.isObject(options)) {
            return _.clone(options) || {};
          }
        }

        function configureForFeatures(features) {
          var featureConfigs = _.map(features, function (featureOptions, feature) {
            if (_.contains(settings.features, feature)) {
              return handleOptions(featureOptions.enable);
            } else {
              return handleOptions(featureOptions.disable);
            }
          });

          $.when.apply($, featureConfigs)
            .done(function () {
              var featureConfig = _.deepExtend.apply(_, arguments);
              require.config(featureConfig);
            }).then(function () {
              callback();
            });
        }

        configureForFeatures(features);

      });
    };
  });

})();
