// APP_LOCAL_GITEA_URL

module.exports = {
    'Gitea First Login' : function (browser) {
      console.log("URL = "+browser.config.gitea.url + "/user/sign_up");
      browser
        .url(browser.config.gitea.url + "/user/sign_up")
        .waitForElementVisible('body', 1000)
        .setValue("input[name='user_name']", process.env.SERVICE_GITEA_ESADMIN_CREDENTIALS_USER_NAME)
        .setValue("input[name='email']", process.env.SERVICE_GITEA_ESADMIN_CREDENTIALS_EMAIL)
        .setValue("input[name='password']", process.env.SERVICE_GITEA_ESADMIN_CREDENTIALS_PASSWORD)
        .setValue("input[name='retype']", process.env.SERVICE_GITEA_ESADMIN_CREDENTIALS_PASSWORD)
        .click("button")
        .waitForElementVisible("#user_name")

//        .assert.containsText('p', "The authentication 'esgw' has been added.")

    }
  };
