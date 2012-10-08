#=============================================================================
#
# Copyright © 2012 Lawrence Leonard Gilbert
#
# This software is governed by the terms of the MIT License.  Please see the
# 'LICENSE' file included in this distribution, or if it has been lost, please
# see the license text at: http://opensource.org/licenses/MIT
#
#=============================================================================
# File: lib/fubar.rb
#=============================================================================

require 'watir-webdriver'

class Fubar

    @@home_url  = 'http://fubar.com/home.php'
    @@login_url = 'http://fubar.com/login.php'

    # exceptions
    class IAmLost < Exception; end

    attr_accessor :browser, :login, :password
    private :password

    def initialize(args = {})
        args[:browser] ||= :chrome
        @browser   = Watir::Browser.start(@@login_url, args[:browser])
        @login     = args[:login]
        @password  = args[:password]
        @logged_in = false
        log_in_user if @login and @password
    end

    def log_in_user
        raise "Login not defined" unless @login
        raise "Password not defined" unless @password
        login_field = browser.input(id: '_user')
        password_field = browser.input(id: '_pw')
        submit_button = browser.element(id: 'loginbutton')
        unless
          [login_field, password_field, submit_button].all?{|el| el.exists?}
            raise IAmLost, "This doesn't look like the login page"
        end
        login_field.focus

        # Using tab to switch fields seems to be most straightforward
        # and least error-prone
        login_field.send_keys(login + "\t")
        password_field.send_keys(password)
        submit_button.click

        # Going to the URL in @@home_url == success
        # Going back to the login page with empty password field == fail
        # Anything else == assumed fail
        begin
            Watir::Wait.until {
                browser.url == @@home_url or
                password_field.text == ""
            }
        rescue Exception => exception
            $stderr.puts exception.inspect
        end
        @logged_in = (browser.url == @@home_url)
    end

    def logged_in?
        !!@logged_in
    end
end
