require "selenium-webdriver"

wait = Selenium::WebDriver::Wait.new(:timeout => 5)

driver = Selenium::WebDriver.for :remote, url: ENV['PHANTOMJS_URL']

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
driver.manage.window.size = target_size

user = ENV['SERVICE_ARCHIVA_ADMIN_CREDENTIALS_USER_NAME']
pass = ENV['SERVICE_ARCHIVA_ADMIN_CREDENTIALS_PASSWORD']
email = ENV['SERVICE_ARCHIVA_ADMIN_CREDENTIALS_EMAIL']

driver.navigate.to "#{ENV["ARCHIVA_URL"]}"

sleep 5

driver.find_element(:id, "create-admin-link-a").click

sleep 5

driver.find_element(:id, "password").send_keys pass
driver.find_element(:id, "confirmPassword").send_keys pass

driver.find_element(:id, "email").send_keys email

driver.find_element(:id, "validated").click

driver.find_element(:id, "user-create-form-register-button").click

sleep 5

driver.quit

