require 'rubygems'
require 'bundler/setup'

require 'engtagger'
require 'yaml'

class Aliza
    #include Memory

    def initialize
        @spine = Spine.new
        @mouth = Mouth.new(@spine)
        @ear = Ear.new(@spine)
        @brain = Brain.new(@spine)
    end

    def start
        @spine.execute
    end
end
