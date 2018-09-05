require "selenium-webdriver"

Selenium::WebDriver.logger.level = :debug

wait = Selenium::WebDriver::Wait.new(:timeout => 5)

driver = Selenium::WebDriver.for :remote, url: ENV['PHANTOMJS_URL']

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
# driver.manage.window.size = target_size

driver.navigate.to "#{ENV["SERVICE_GOGS_ROOT_CREDENTIALS_URL"]}/user/sign_up"

sleep 5

user = ENV['SERVICE_GOGS_ROOT_CREDENTIALS_USER_NAME']
pass = ENV['SERVICE_GOGS_ROOT_CREDENTIALS_PASSWORD']
email = ENV['SERVICE_GOGS_ROOT_CREDENTIALS_EMAIL']

driver.find_element(:id, "user_name").send_keys user
driver.find_element(:id, "email").send_keys email
driver.find_element(:id, "password").send_keys pass
driver.find_element(:id, "retype").send_keys pass

driver.find_element(:tag_name, "button").click

sleep 5

wait.until { driver.find_element(:id, "user_name").displayed? }

driver.quit

