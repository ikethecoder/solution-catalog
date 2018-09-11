// APP_LOCAL_GOCD_URL

module.exports = {
    'Set OAuth for APIs' : function (browser) {
      browser
        .url(browser.config.gocd.url + "/admin/security/auth_configs")
        .waitForElementVisible('body', 1000)
        .waitAndClick('.add-auth-config')
        .setValue("input[data-prop-name='id']", "esgw_apis")
        .click("select[data-prop-name='pluginId']")
        .click("option[value='cd.go.authorization.passwordfile']")
        .setValue("input[ng-model='PasswordFilePath']", "/godata/password.properties")
        .click("button.save")
        .waitForElementVisible("#user_login");
    }
  };
