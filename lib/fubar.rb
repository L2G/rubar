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
    class NoSuchMember < Exception; end

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

    def find_member(args = {})
        unless args.keys.size == 1
            raise "Don't know what to do with #{args}"
        end
        (how, value) = *(args.reduce)

        case how
        when :id
            find_member_by_id(value)
        else
            raise "Don't know how to find by #{how}"
        end

    end

    def find_member_by_id(value)
        was_found = false
        name = nil

        raise "ID must be numeric but was #{value}" unless
            value.kind_of?(Integer)
        browser.goto("http://fubar.com/#{value}")
        begin
            Watir::Wait.until {
                if browser.text =~ %r{invalid member}
                    raise NoSuchMember
                elsif ( browser.url == "http://fubar.com/#{value}" or
                     browser.title =~ %r{^(.*?) / (.*?) \(#{value}\)} )
                    was_found = true
                    match_results = %r{^(.*?) / (.*?) \(}.match(browser.title)
                    name = match_results[1]
                end
            }
        #rescue Exception => exception
        #    $stderr.puts exception.inspect
        end
        if was_found
            Fubar::Member.new(
                id: value,
                url: browser.url,
                name: name
            )
        else
            nil
        end
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
