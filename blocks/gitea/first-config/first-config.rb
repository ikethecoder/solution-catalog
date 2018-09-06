require "selenium-webdriver"

Selenium::WebDriver.logger.level = :debug

wait = Selenium::WebDriver::Wait.new(:timeout => 5)

driver = Selenium::WebDriver.for :remote, url: ENV['PHANTOMJS_URL']

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
# driver.manage.window.size = target_size

driver.navigate.to "#{ENV["SERVICE_GITEA_ESADMIN_CREDENTIALS_URL"]}/user/login"

sleep 5

user = ENV['SERVICE_GITEA_ESADMIN_CREDENTIALS_USER_NAME']
pass = ENV['SERVICE_GITEA_ESADMIN_CREDENTIALS_PASSWORD']

driver.find_element(:id, "user_name").send_keys user
driver.find_element(:id, "password").send_keys pass

driver.find_element(:tag_name, "button").click

sleep 2

driver.navigate.to "#{ENV["SERVICE_GITEA_ESADMIN_CREDENTIALS_URL"]}/admin/auths/new"

wait.until { driver.find_element(:tag_name, "form").displayed? }

driver.find_element(:xpath, "//form/div/div").click
driver.find_element(:xpath, "//div[5]").click


driver.find_element(:xpath, "//div[6]/div/div").click
driver.find_element(:xpath, "//div[6]/div/div/div[2]/div[5]").click


driver.find_element(:id, "name").send_keys 'OAUTH'

driver.find_element(:id, "oauth2_use_custom_url").click

driver.find_element(:id, "oauth2_key").send_keys 'key'
driver.find_element(:id, "oauth2_secret").send_keys 'secret'

wait.until { driver.find_element(:id, "oauth2_auth_url").displayed? }

driver.find_element(:id, "oauth2_auth_url").clear
driver.find_element(:id, "oauth2_auth_url").send_keys 'auth_url'
driver.find_element(:id, "oauth2_token_url").send_keys 'token_url'
driver.find_element(:id, "oauth2_profile_url").send_keys 'profile_url'

driver.find_element(:xpath, "//button").click

driver.save_screenshot("screenshot.png")

driver.quit

