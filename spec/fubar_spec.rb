#=============================================================================
#
# Copyright © 2012 Lawrence Leonard Gilbert
#
# This software is governed by the terms of the MIT License.  Please see the
# 'LICENSE' file included in this distribution, or if it has been lost, please
# see the license text at: http://opensource.org/licenses/MIT
#
#=============================================================================
# File: spec/fubar_spec.rb
#=============================================================================

require 'fubar'
require_relative '../rubar_config'

describe "Fubar" do

    context "#new with no params" do
        it "creates a Fubar instance" do
            @fubar = Fubar.new
            @fubar.should be_a_kind_of(Fubar)
            @fubar.browser.quit
        end
    end

    context "#new with login info" do
        before(:all) do
            @fubar = Fubar.new(login:    configatron.fubar.login,
                               password: configatron.fubar.password)
        end

        it "creates a Fubar instance" do
            @fubar.should be_a_kind_of(Fubar)
        end

        it "automatically logs in to fubar" do
            @fubar.logged_in?.should be_true
        end

        after(:all) do
            @fubar.browser.quit
        end
    end

    context "#new with BAD login info" do
        before(:all) do
            @fubar = Fubar.new(login:    configatron.fubar.login,
                               password: 'XXXXXXXXXXX')
        end

        it "creates a Fubar instance" do
            @fubar.should be_a_kind_of(Fubar)
        end

        it "fails to log in to fubar" do
            @fubar.logged_in?.should be_false
        end

        after(:all) do
            @fubar.browser.quit
        end
    end

    context "#find_member" do
        before(:all) do
            @fubar = Fubar.new
        end

        it "raises exception if means of finding is unknown" do
            lambda {
                @fubar.find_member(:fnord => true)
            }.should raise_exception
        end

        context "by ID" do
            before(:all) do
                @babyjesus = @fubar.find_member(id: 1)
            end

            it "should raise exception for an invalid ID" do
                lambda {
                    @fubar.find_member(id: 2434334874)
                    }.should raise_exception(Fubar::NoSuchMember)
            end

            it "should return a Fubar::Member for a valid ID" do
                @babyjesus.should be_an_instance_of(Fubar::Member)
            end

            it "should have the correct ID for the member" do
                @babyjesus.id.should == 1
            end

            it "should have the correct URL for the member" do
                @babyjesus.url.should == 'http://fubar.com/babyjesus'
            end

            it "should have the correct name for the member" do
                @babyjesus.name.should == 'babyjesus'
            end

        end

        after(:all) do
            @fubar.browser.quit
        end
    end
end
