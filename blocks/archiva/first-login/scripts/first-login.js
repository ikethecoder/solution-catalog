// APP_LOCAL_GITEA_URL

module.exports = {
    'Archiva First Login' : function (browser) {
      console.log("Archiva: " + browser.config.archiva.url)
      browser
        .url(browser.config.archiva.url)
        .waitForElementVisible('#create-admin-link-a', 5000)
        .click("#create-admin-link-a")
        .waitForElementVisible("input[name='password']", 3000)
        .setValue("input[name='password']", process.env.SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_PASSWORD)
        .setValue("input[name='confirmPassword']", process.env.SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_PASSWORD)
        .setValue("input[name='email']", process.env.SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_EMAIL)
        .click("input[name='validated']")
        .waitForElementVisible("#user-create-form-register-button", 3000)
        .click("#user-create-form-register-button")

    }
  };
