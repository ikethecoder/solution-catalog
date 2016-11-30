require "selenium-webdriver"

wait = Selenium::WebDriver::Wait.new(:timeout => 5)

#driver = Selenium::WebDriver.for :remote, :url => "http://localhost:4444", :desired_capabilities => :firefox

driver = Selenium::WebDriver.for :firefox

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
# driver.manage.window.size = target_size

driver.navigate.to 'http://www.google.com'

sleep 5
driver.save_screenshot("/tmp/screen.png")
