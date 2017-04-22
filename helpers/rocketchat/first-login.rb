require "selenium-webdriver"

wait = Selenium::WebDriver::Wait.new(:timeout => 5)

driver = Selenium::WebDriver.for :remote, url: ENV['PHANTOMJS_URL']

driver.manage.delete_all_cookies

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
# driver.manage.window.size = target_size


driver.navigate.to ENV['ROCKETCHAT_URL'] + "/home"

counter = 1

define_method(:screenshot) do
    puts "Saving screenshot#{counter}.png"
	driver.save_screenshot("/usr/share/nginx/html/screenshot#{counter}.png")
	counter = counter + 1
end

define_method(:nextAction) do
	begin
	   wait.until {
            driver.find_element(:xpath, "//button[contains(text(), 'Register a new account')]").displayed? or
            driver.find_element(:xpath, "//button[contains(text(), 'Please Wait...')]").displayed? or
            driver.find_element(:xpath, "//button/span[contains(text(), 'Use this username')]").displayed?
	   }
	   if ( driver.find_element(:xpath, "//button[contains(text(), 'Register a new account')]").displayed? )
		return "REGISTER_NEW_ACCOUNT"
	   end
           if ( driver.find_element(:xpath, "//button[contains(text(), 'Use this username')]").displayed? )
                return "USE_USERNAME"
           end
           if ( driver.find_element(:xpath, "//button[contains(text(), 'Please Wait...')]").displayed? )
                return "PLEASE_WAIT"
           end

	rescue
		screenshot()
		return "NO_MATCH"
	end

end


begin

    puts nextAction()

    begin
       wait.until { driver.find_element(:xpath, "//button[contains(text(), 'Register a new account')]").displayed? }
    rescue
       puts "Looks like we were logged in..."
       driver.find_element(:tag_name => "h4").click
       puts "Opened admin"
       wait.until { driver.find_element(:id, "logout").displayed? }
       driver.find_element(:id, "logout").click
       puts "Safe to register name"
    end

    wait.until { driver.find_element(:xpath, "//button[contains(text(), 'Register a new account')]").displayed? }
    driver.find_element(:xpath, "//button[contains(text(), 'Register a new account')]").click

    driver.find_element(:name, "name").send_keys "admin"
    driver.find_element(:name, "email").send_keys "aidan.cope@gmail.com"
    driver.find_element(:name, "pass").send_keys "admin1admin"
    driver.find_element(:name, "confirm-pass").send_keys "admin1admin"
#    driver.save_screenshot('/usr/share/nginx/html/screenshot.png')

    driver.find_element(:class, "primary").click

# NOTE: THE H2 WARNING can appear NOW!
    wait.until { driver.find_element(:xpath => "//button/span[contains(text(), 'Use this username')]").displayed? }

    #driver.save_screenshot('/usr/share/nginx/html/screenshot.png')

    # Confirm that the username can be used
    driver.find_element(:xpath, "//button/span[contains(text(), 'Use this username')]").click

    sleep 2

rescue Exception => e
    puts "Error - recording a screenshot"
    driver.save_screenshot('/tmp/screenshot.png')
    raise e
end

driver.quit
