// APP_LOCAL_GITEA_URL

module.exports = {
    'Archiva First Login' : function (browser) {
      console.log("URL = "+browser.config.archiva.url);
      browser
        .url(browser.config.gitea.url)
        .waitForElementVisible('body', 1000)
        .click("#create-admin-link-a")
        .setValue("input[name='password']", process.env.SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_PASSWORD)
        .setValue("input[name='confirmPassword']", process.env.SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_PASSWORD)
        .setValue("input[name='email']", process.env.SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_EMAIL)
        .click("input[name='validated']")
        .click("input[id='user-create-form-register-button']")

    }
  };
