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
        .waitAndClick("div[data-value='openidConnect']")
        .setValue("#oauth2_key", "gitea")
        .setValue("#oauth2_secret", process.env.OAUTH_CLIENTS_GITEA_CLIENT_SECRET)
//        .useXpath().waitAndClick("//div[5]/div/label").useCss()

        .waitForElementVisible("#open_id_connect_auto_discovery_url")

        .clearValue("#open_id_connect_auto_discovery_url")
        .setValue("#open_id_connect_auto_discovery_url", process.env.OAUTH_CLIENTS_GITEA_OIDC_DISCOVERY)

        .click("button.green")
        .assert.containsText('p', "The authentication 'esgw' has been added.")

    }
  };
