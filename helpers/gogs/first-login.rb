require "selenium-webdriver"

wait = Selenium::WebDriver::Wait.new(:timeout => 5)

driver = Selenium::WebDriver.for :remote, url: ENV['PHANTOMJS_URL']

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
# driver.manage.window.size = target_size

driver.navigate.to "#{ENV["GOGS_URL"]}/user/sign_up"

sleep 5

driver.find_element(:id, "user_name").send_keys "admin"
driver.find_element(:id, "email").send_keys "admin@canzea.com"
driver.find_element(:id, "password").send_keys "admin1admin"
driver.find_element(:id, "retype").send_keys "admin1admin"

driver.find_element(:name, "commit").click

sleep 5

driver.quit

