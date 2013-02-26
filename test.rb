require "test/unit"
load "aliza.rb"

class TestAliza < Test::Unit::TestCase
    def test_greeting
        assert_equal("Hello, I am Aliza. What is your name?", Aliza.new.speak)

    end
end
