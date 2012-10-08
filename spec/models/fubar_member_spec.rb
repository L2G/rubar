#=============================================================================
#
# Copyright © 2012 Lawrence Leonard Gilbert
#
# This software is governed by the terms of the MIT License.  Please see the
# 'LICENSE' file included in this distribution, or if it has been lost, please
# see the license text at: http://opensource.org/licenses/MIT
#
#=============================================================================
# File: spec/models/fubar_member_spec.rb
#=============================================================================

require 'fubar/member'
require_relative '../../rubar_config'

describe Fubar::Member do
    before(:all) do
        @basic_instance = Fubar::Member.new
    end

    context "#new" do
        it "should create an instance of Fubar::Member" do
            @basic_instance.should be_an_instance_of(Fubar::Member)
        end
    end

    context "instance" do
        methods = [
            :name, :id, :url, :date_joined, :relationship_status,
            :daily_rank, :buzz_meter, :buzz_meter_label,
            :rating, :rating_count, :likes_count,
            :level, :level_name, :points, :fumafia_rating,
            :friend_count, :fan_count, :family_count, :fan_count,
            :fan_of_count,
            :fuowned_by, :fuowned_worth
        ]
        it "should respond to predefined methods" do
            @basic_instance.should respond_to(*methods)
        end
        #methods.each do |method|
        #    it "should have method #{method}" do
        #        @basic_instance.should respond_to(method)
        #    end
        #end
    end
end
