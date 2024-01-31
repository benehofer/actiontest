{
    "analyzers": {
      "core": {
        "enabled": true,
        "rules": {
          "adminusername-should-not-be-literal": {
            "level": "warning"
          },
          "artifacts-parameters": {
            "level": "warning"
          },
          "decompiler-cleanup": {
            "level": "warning"
          },
          "max-outputs": {
            "level": "warning"
          },
          "max-params": {
            "level": "warning"
          },
          "max-resources": {
            "level": "warning"
          },
          "max-variables": {
            "level": "warning"
          },
          "no-hardcoded-env-urls": {
            "level": "warning"
          },
          "no-hardcoded-location": {
            "level": "warning"
          },
          "no-loc-expr-outside-params": {
            "level": "warning"
          },
          "no-unnecessary-dependson": {
            "level": "warning"
          },
          "no-unused-existing-resources": {
            "level": "warning"
          },
          "no-unused-params": {
            "level": "off"
          },
          "no-unused-vars": {
            "level": "warning"
          },
          "outputs-should-not-contain-secrets": {
            "level": "warning"
          },
          "prefer-interpolation": {
            "level": "warning"
          },
          "prefer-unquoted-property-names": {
            "level": "warning"
          },
          "protect-commandtoexecute-secrets": {
            "level": "warning"
          },
          "secure-parameter-default": {
            "level": "warning"
          },
          "secure-params-in-nested-deploy": {
            "level": "warning"
          },
          "secure-secrets-in-params": {
            "level": "warning"
          },
          "simplify-interpolation": {
            "level": "warning"
          },
          "simplify-json-null": {
            "level": "warning"
          },
          "use-parent-property": {
            "level": "warning"
          },
          "use-recent-api-versions": {
            "level": "warning",
            "maxAllowedAgeInDays": 730
          },
          "use-resource-id-functions": {
            "level": "warning"
          },
          "use-resource-symbol-reference": {
            "level": "warning"
          },
          "use-stable-resource-identifiers": {
            "level": "warning"
          },
          "use-stable-vm-image": {
            "level": "warning"
          }
        }
      }
    }
  }