require "selenium-webdriver"

wait = Selenium::WebDriver::Wait.new(:timeout => 5)

driver = Selenium::WebDriver.for :remote, url: ENV['PHANTOMJS_URL']

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
# driver.manage.window.size = target_size

driver.navigate.to ENV["GITLAB_URL"]

sleep 5

driver.find_element(:id, "user_password").send_keys "admin1admin1"
driver.find_element(:id, "user_password_confirmation").send_keys "admin1admin1"

driver.find_element(:name, "commit").click

sleep 5

driver.quit

