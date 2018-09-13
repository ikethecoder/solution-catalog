// APP_LOCAL_GITEA_URL

module.exports = {
    'Set Rocket.Chat OAuth' : function (browser) {
      console.log("URL = "+browser.config.rocketchat.url + "/user/login");

      var setValue =  function(sel, value) {
        $(sel).val(value).change();
      };

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
            .waitAndClick("a[aria-label='OAuth']")
            .waitAndClick("button.add-custom-oauth")

            .setValue("input[name='name']", "esgw")
            .waitAndClick("input[data-button='create']")


            .assert.containsText('div.section-title-text', "Custom OAuth: Esgw")

            .useXpath().waitAndClick("//div[@id='rocket-chat']/div[2]/section/div/div/div/div/div[2]/button").useCss()


            .waitForElementVisible("input[name='Accounts_OAuth_Custom-Esgw-url']")
            .clearValue("input[name='Accounts_OAuth_Custom-Esgw-url']").setValue("input[name='Accounts_OAuth_Custom-Esgw-url']", process.env.OAUTH_CLIENTS_ROCKETCHAT_OAUTH2_ROOT)

            .click("input[name='Accounts_OAuth_Custom-Esgw'][value='1']")

            .waitAndClick("select[name='Accounts_OAuth_Custom-Esgw-login_style']")
            .waitAndClick("option[value='redirect']")

            .clearValue("input[name='Accounts_OAuth_Custom-Esgw-id']").setValueSlow("input[name='Accounts_OAuth_Custom-Esgw-id']", 'rocketchat')
            .clearValue("input[name='Accounts_OAuth_Custom-Esgw-secret']").setValueSlow("input[name='Accounts_OAuth_Custom-Esgw-secret']", process.env.OAUTH_CLIENTS_ROCKETCHAT_CLIENT_SECRET)

            .waitForElementVisible("input[name='Accounts_OAuth_Custom-Esgw-button_label_text']").clearValue("input[name='Accounts_OAuth_Custom-Esgw-button_label_text']").setValue("input[name='Accounts_OAuth_Custom-Esgw-button_label_text']", 'Ecosystem Gateway')

            .saveScreenshot("/screenshots/s1.png")

            .click("button.save")

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
