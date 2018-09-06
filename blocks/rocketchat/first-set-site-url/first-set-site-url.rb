require "selenium-webdriver"

# ENV['SECRET_KEY_XXYY'] || raise('no SECRET_KEY_XXYY provided')

['ROCKETCHAT_URL'].each do |var|
    if ! ENV.has_key?(var)
        raise "#{var} is a required environment variable"
    end
end

wait = Selenium::WebDriver::Wait.new(:timeout => 2)

driver = Selenium::WebDriver.for :remote, url: ENV['PHANTOMJS_URL']

driver.manage.delete_all_cookies

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
#driver.manage.window.size = target_size

driver.navigate.to ENV['ROCKETCHAT_URL'] + "/home"

user = ENV['SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_USER_NAME']
pass = ENV['SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_PASSWORD']
url = ENV['SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_URL']

begin
    begin
       wait.until { driver.find_element(:name => "emailOrUsername").displayed? }
    rescue
       puts "Looks like we were logged in..."

       wait.until { driver.find_element(:tag_name => "h4").displayed? }
       driver.find_element(:tag_name => "h4").click
       puts "Opened admin"
       wait.until { driver.find_element(:id, "logout").displayed? }
       driver.find_element(:id, "logout").click
       puts "Safe to login"

    end

    puts "Logging in..."

    wait.until { driver.find_element(:name => "emailOrUsername").displayed? }

    # driver.save_screenshot('/home/nginx/www/screenshot0.png')

    puts "Email"
    driver.find_element(:name, "emailOrUsername").send_keys user
    puts "Password"
    driver.find_element(:name, "pass").send_keys pass

    puts "Click login"
    driver.find_element(:class, "login").click

    # driver.save_screenshot('/home/nginx/www/screenshot1.png')

    sleep 4

    puts "Confirming..."

   begin
    wait.until { driver.find_element(:class => "confirm") }
    driver.find_element(:class => "confirm").click
   rescue
    puts "No CONFIRM button seen"
   end

    wait.until { driver.find_element(:tag_name, "h4").displayed? }
    driver.find_element(:tag_name => "h4").click

    wait.until { driver.find_element(:id, "admin").displayed? }
    driver.find_element(:id, "admin").click

    wait.until { driver.find_element(:link, "General").displayed? }
    driver.find_element(:link, "General").click

    # driver.save_screenshot('/home/nginx/www/screenshot1.png')

    wait.until { driver.find_element(:name, "Site_Url").displayed? }

    # driver.save_screenshot('/home/nginx/www/screenshot1.png')

    txt = driver.find_element(:name, "Site_Url")['value']

    puts "Comparing #{txt} with #{ENV['ROCKETCHAT_URL']}"
    if txt != url
      driver.find_element(:name, "Site_Url").clear
      driver.find_element(:name, "Site_Url").send_keys url

      driver.find_element(:name, "Site_Name").send_keys ""

      # driver.save_screenshot('/home/nginx/www/screenshot1.png')

      wait.until { driver.find_element(:class, "save").displayed? }

      driver.find_element(:class, "save").click
    else
      puts "Site Url already set correctly"
    end

    sleep 4
rescue Exception => e
    puts "Error - recording a screenshot"
    driver.save_screenshot('/tmp/screenshot.png')
    raise e
end

puts "Done"

driver.quit

