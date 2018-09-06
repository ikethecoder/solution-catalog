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

oauth_secret = ENV['OAUTH_CLIENTS_GITEA_CLIENT_SECRET']
oauth2_authorize = ENV['OAUTH_CLIENTS_GITEA_OAUTH2_AUTHORIZE']
oauth2_token = ENV['OAUTH_CLIENTS_GITEA_OAUTH2_TOKEN']
oauth2_profile = ENV['OAUTH_CLIENTS_GITEA_OAUTH2_PROFILE']

driver.navigate.to "#{ENV["SERVICE_GITEA_ESADMIN_CREDENTIALS_URL"]}/admin/auths/new"

wait.until { driver.find_element(:tag_name, "form").displayed? }

driver.find_element(:xpath, "//form/div/div").click
driver.find_element(:xpath, "//div[5]").click


driver.find_element(:xpath, "//div[6]/div/div").click
driver.find_element(:xpath, "//div[6]/div/div/div[2]/div[5]").click


driver.find_element(:id, "name").send_keys 'ecosystem-gw'

driver.find_element(:id, "oauth2_use_custom_url").click

driver.find_element(:id, "oauth2_key").send_keys 'gitea'
driver.find_element(:id, "oauth2_secret").send_keys oauth_secret

wait.until { driver.find_element(:id, "oauth2_auth_url").displayed? }

driver.find_element(:id, "oauth2_auth_url").clear
driver.find_element(:id, "oauth2_auth_url").send_keys oauth2_authorize

driver.find_element(:id, "oauth2_token_url").clear
driver.find_element(:id, "oauth2_token_url").send_keys oauth2_token

driver.find_element(:id, "oauth2_profile_url").clear
driver.find_element(:id, "oauth2_profile_url").send_keys oauth2_profile

driver.find_element(:xpath, "//button").click

driver.save_screenshot("screenshot.png")

driver.quit

