
module.exports = {
    'Set Rocket.Chat Site URL' : function (browser) {
      console.log("URL = "+browser.config.rocketchat.url + "/user/login");
      browser
        .url(browser.config.rocketchat.url + "/home")
        .waitForElementVisible('body', 1000)
        .setValue("input[name='emailOrUsername']", process.env.SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_USER_NAME)
        .setValue("input[name='pass']", process.env.SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_PASSWORD)
        .click("button.login")


        browser.element('css selector', 'h1.rc-modal__title', function(result){
            if (result.value && result.value.ELEMENT) {
                // Element is present, do the appropriate tests
                browser.waitAndClick("input[data-button='create']");
            }
            // Element is not present.
            browser
            .waitAndClick("button[aria-label='Options']")
            .waitAndClick("li[data-id='administration']")
            .waitAndClick("a[aria-label='General']")

            .waitForElementVisible("input[name='Site_Url']")
            .clearValue("input[name='Site_Url']")
            .setValueSlow("input[name='Site_Url']", process.env.SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_URL)

            .waitAndClick("button.save")

            .saveScreenshot("/screenshots/s2.png")
        });

      //   browser
      //   .assert.containsText('h1', "Warning")
      //   .waitAndClick("input[data-button='create']")
      // } catch (e) {
      //   console.log("No site warning - good to continue.");
      // }


        //.assert.containsText('p', "Settings updated")

    }
  };
