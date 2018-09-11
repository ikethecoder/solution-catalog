// APP_LOCAL_GOCD_URL

module.exports = {
    'Set OAuth' : function (browser) {
      browser
        .url(browser.config.gocd.url + "/admin/security/auth_configs")
        .waitForElementVisible('body', 1000)
        .waitAndClick('.add-auth-config')
        .setValue("input[data-prop-name='id']", "esgw")
        .click("select[data-prop-name='pluginId']")
        .click("option[value='cd.go.authorization.generic']")
        .setValue("input[ng-model='GenericEndpoint']", process.env.OAUTH_CLIENTS_GOCD_OAUTH2_ROOT_URL)
        .setValue("input[ng-model='ClientId']", 'gocd')
        .setValue("input[ng-model='ClientSecret']", process.env.OAUTH_CLIENTS_GOCD_CLIENT_SECRET)
        .click("button.save")
        .waitForElementVisible("#user_login");
    }
  };
