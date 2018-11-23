// APP_LOCAL_GITEA_URL

module.exports = {
    'Rocketchat First Login' : function (browser) {
      console.log("Rocketchat: " + browser.config.rocketchat.url + "/setup-wizard")
      browser
        .url(browser.config.rocketchat.url + "/setup-wizard")
        .waitForElementVisible("input[name='registration-name']", 3000)
        .setValue("input[name='registration-name']", process.env.SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_USER_NAME)
        .setValue("input[name='registration-username']", process.env.SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_USER_NAME)
        .setValue("input[name='registration-email']", process.env.SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_EMAIL)
        .setValue("input[name='registration-pass']", process.env.SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_PASSWORD)

        .useXpath()
        .waitForElementVisible("//button", 2000)
        .click("//button")

        .useCss()
        .waitForElementVisible("select[name='Organization_Type']", 3000)
        //.setValue("select[name='Organization_Type']", process.env.SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_USER_NAME)

        .click("select[name='Organization_Type'] option[text='Community']")

        .setValue("input[name='confirmPassword']", process.env.SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_PASSWORD)
        .setValue("input[name='email']", process.env.SERVICE_ARCHIVA_ESADMIN_CREDENTIALS_EMAIL)
        .click("input[name='validated']")
        .waitForElementVisible("#user-create-form-register-button", 3000)
        .click("#user-create-form-register-button")

    }
  };
