require "selenium-webdriver"

wait = Selenium::WebDriver::Wait.new(:timeout => 5)

driver = Selenium::WebDriver.for :remote, url: ENV['PHANTOMJS_URL']

driver.manage.delete_all_cookies

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
# driver.manage.window.size = target_size

user = ENV['SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_USER_NAME']
pass = ENV['SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_PASSWORD']
email = ENV['SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_EMAIL']
url = ENV['SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_URL']

driver.navigate.to ENV['ROCKETCHAT_URL'] + "/setup-wizard"

counter = 1

define_method(:screenshot) do
    puts "Saving screenshot#{counter}.png"
	driver.save_screenshot("screenshot#{counter}.png")
	counter = counter + 1
end


begin

    wait.until { driver.find_element(:name, "registration-name").displayed? }

    driver.find_element(:name, "registration-name").send_keys user
    driver.find_element(:name, "registration-username").send_keys user
    driver.find_element(:name, "registration-email").send_keys email
    driver.find_element(:name, "registration-pass").send_keys pass

    wait.until { driver.find_element(:xpath, "//button").enabled? }

    driver.find_element(:xpath, "//button").click

    wait.until { driver.find_element(:name, "Organization_Type").displayed? }

    dropDownMenu = driver.find_element(:name, "Organization_Type")
    option = Selenium::WebDriver::Support::Select.new(dropDownMenu)
    option.select_by(:text, 'Community')

    driver.find_element(:xpath, "//button/span").click

    wait.until { driver.find_element(:name, "Site_Name").displayed? }

    driver.find_element(:name, "Site_Name").send_keys url

    dropDownMenu = driver.find_element(:name, "Server_Type")
    option = Selenium::WebDriver::Support::Select.new(dropDownMenu)
    option.select_by(:text, 'Private Team')

    driver.find_element(:xpath, "//button[@type='submit']").click

    driver.find_element(:xpath, "//label[2]/div/span").click
    driver.find_element(:xpath, "//button[@type='submit']").click

    wait.until { driver.find_element(:css, "h1.setup-wizard-info__content-title.setup-wizard-final__box-title").text.include? "Your workspace is ready to use" }

    driver.find_element(:xpath, "//button").click

    sleep 2

rescue Exception => e
    puts "Error - recording a screenshot"
    driver.save_screenshot('screenshot.png')
    raise e
end

driver.quit
