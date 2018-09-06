require "selenium-webdriver"

# ENV['SECRET_KEY_XXYY'] || raise('no SECRET_KEY_XXYY provided')



[].each do |var|
    if ! ENV.has_key?(var)
        raise "#{var} is a required environment variable"
    end
end

user = ENV['SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_USER_NAME']
pass = ENV['SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_PASSWORD']
url = ENV['SERVICE_ROCKETCHAT_ESADMIN_CREDENTIALS_URL']

oauth_secret = ENV['OAUTH_CLIENTS_ROCKETCHAT_CLIENT_SECRET']
oauth2_authorize = ENV['OAUTH_CLIENTS_ROCKETCHAT_OAUTH2_AUTHORIZE']
oauth2_token = ENV['OAUTH_CLIENTS_ROCKETCHAT_OAUTH2_TOKEN']
oauth2_profile = ENV['OAUTH_CLIENTS_ROCKETCHAT_OAUTH2_PROFILE']


wait = Selenium::WebDriver::Wait.new(:timeout => 20)

# options = Selenium::WebDriver::Chrome::Options.new
# options.add_argument('--headless')
# driver = Selenium::WebDriver.for :chrome, options: options

driver = Selenium::WebDriver.for :remote, url: ENV['PHANTOMJS_URL']

driver.manage.delete_all_cookies

target_size = Selenium::WebDriver::Dimension.new(1024, 768)
# driver.manage.window.size = target_size

driver.navigate.to url + "/admin/OAuth"


begin
    begin
       wait.until { driver.find_element(:name => "emailOrUsername").displayed? }
    rescue
       puts "Looks like we were logged in..."

       wait.until { driver.find_element(:css => "img.avatar-image").displayed? }
       driver.find_element(:css => "img.avatar-image").click

       puts "Opened admin"
       wait.until { driver.find_element(:xpath, "//ul[2]/li[2]/span[2]").displayed? }
       # Logout
       driver.find_element(:xpath, "//ul[2]/li[2]/span[2]").click
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


    sleep 4


    puts "Confirming..."

#    wait.until { driver.find_element(:css => "img.avatar-image").displayed? }

#     driver.find_element(:css, "span.rc-popover__item-text").click

#     driver.find_element(:xpath, "//a[contains(@href,'/admin/OAuth')").click

    sleep 4
    driver.save_screenshot('screenshot1.png')

    wait.until { driver.find_element(:class, "add-custom-oauth") }


    driver.find_element(:class, "add-custom-oauth").click


    wait.until { driver.find_element(:tag_name => "input") }

    driver.find_element(:tag_name, "input").send_keys "ecosystem-gw"
    driver.find_element(:class, "confirm").click

    sleep 2

    driver.navigate.to "#{url}/admin/admin/OAuth"

    driver.find_element(:xpath, "//div[@id='rocket-chat']/div[2]/section/div/div/div/div/div[2]/button/span").click

    driver.find_element(:css, "div.setting-field > label").click

    driver.find_element(:name, "name=Accounts_OAuth_Custom-Ecosystemgw-url").send_keys "#{url}/_oauth/ecosystemgw"
    driver.find_element(:name, "name=Accounts_OAuth_Custom-Ecosystemgw-token_path").send_keys oauth2_token
    driver.find_element(:name, "name=Accounts_OAuth_Custom-Ecosystemgw-authorizer_path").send_keys oauth2_token
    driver.find_element(:name, "name=Accounts_OAuth_Custom-Ecosystemgw-identity_path").send_keys oauth2_profile
    driver.find_element(:name, "name=Accounts_OAuth_Custom-Ecosystemgw-id").send_keys 'rocketchat'
    driver.find_element(:name, "name=Accounts_OAuth_Custom-Ecosystemgw-secret").send_keys oauth_secret

    driver.find_element(:class, "save").click

    sleep 4
rescue Exception => e
    puts "Error - recording a screenshot"
    driver.save_screenshot('screenshot.png')
    raise e
end

puts "Done"

driver.quit

