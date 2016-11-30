require "selenium-webdriver"

wait = Selenium::WebDriver::Wait.new(:timeout => 5)

driver = Selenium::WebDriver.for :phantomjs

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
driver.manage.window.size = target_size

driver.navigate.to "http://localhost:8153/go/admin/config/server"

sleep 5

driver.find_element(:name, "server_configuration_form_password_file_path").send_keys "/root/gocd_passwords"

# NEED TO PUT SOMETHING HERE
driver.find_element(:id, "validated").click

sleep 5

driver.quit

