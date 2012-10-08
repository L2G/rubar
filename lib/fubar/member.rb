#=============================================================================
#
# Copyright © 2012 Lawrence Leonard Gilbert
#
# This software is governed by the terms of the MIT License.  Please see the
# 'LICENSE' file included in this distribution, or if it has been lost, please
# see the license text at: http://opensource.org/licenses/MIT
#
#=============================================================================
# File: lib/fubar/member.rb
#=============================================================================

class Fubar
    class Member
        attr_reader :id, :url, :name

        def initialize(args = {})
            args.each_pair do |key, value|
                instance_variable_set("@#{key}", value)
            end
        end
    end
end
