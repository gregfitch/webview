(function () {
  'use strict';

  define(function () {
    // jshint maxparams: 4
    return function (settings, makeCoachEnabledConfig, _, $) {
      // config per feature as needed. The key should match the feature string in
      // the features' array, and then you can modify the config for either
      // `enable`d or 'disable'd features.
      var features = {
        conceptCoach: {
          base: makeCoachEnabledConfig(settings, _, $)
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
        var featureConfigs = [];
        _.each(features, function (featureOptions, feature) {
          if (!_.isEmpty(featureOptions.base)) {
            featureConfigs.push(handleOptions(featureOptions.base));
          }

          if (_.contains(settings.features, feature)) {
            featureConfigs.push(handleOptions(featureOptions.enable));
          } else {
            featureConfigs.push(handleOptions(featureOptions.disable));
          }
        });

        return $.when.apply($, featureConfigs)
          .done(function () {
            var featureConfig = _.deepExtend.apply(_, arguments);
            if (featureConfig) {
              require.config(featureConfig);
            }
          });
      }

      return configureForFeatures(features);
    };
  });

})();
