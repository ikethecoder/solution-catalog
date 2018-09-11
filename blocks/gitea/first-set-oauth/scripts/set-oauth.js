// APP_LOCAL_GITEA_URL

module.exports = {
    'Set Gitea OAuth' : function (browser) {
      console.log("URL = "+browser.config.gitea.url + "/user/login");
      browser
        .url(browser.config.gitea.url + "/user/login")
        .waitForElementVisible('body', 1000)
        .setValue("input[name='user_name']", process.env.SERVICE_GITEA_ESADMIN_CREDENTIALS_USER_NAME)
        .setValue("input[name='password']", process.env.SERVICE_GITEA_ESADMIN_CREDENTIALS_PASSWORD)
        .click("button.green")
        .waitForElementVisible("div.stackable")
        .saveScreenshot("/screenshots/s.png")

      browser
        .waitAndClick("img.tiny.avatar")
        .waitAndClick("a[href='/admin']")
        .waitAndClick("a[href='/admin/auths']")
        .waitAndClick("a[href='/admin/auths/new']")
        .waitAndClick("div.type")
        .waitAndClick("div[data-value='6']")

        .setValue("#name", "esgw")

        .useXpath()
        .waitAndClick("//div[6]/div/div")
        .useCss()
        .waitAndClick("div[data-value='gitlab']")
        .setValue("#oauth2_key", "gitea")
        .setValue("#oauth2_secret", process.env.OAUTH_CLIENTS_GITEA_CLIENT_SECRET)
        .waitAndClick("div.oauth2_use_custom_url")
        .waitForElementVisible("#oauth2_auth_url")

        .setValue("#oauth2_auth_url", process.env.OAUTH_CLIENTS_GITEA_OAUTH2_AUTHORIZE)
        .setValue("#oauth2_token_url", process.env.OAUTH_CLIENTS_GITEA_OAUTH2_TOKEN)
        .setValue("#oauth2_profile_url", process.env.OAUTH_CLIENTS_GITEA_OAUTH2_PROFILE)

        .click("button.green")
        .assert.containsText('p', "The authentication 'esgw' has been added.")

    }
  };
