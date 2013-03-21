require 'rubygems'
require 'bundler/setup'

require 'engtagger'
require 'yaml'

class Aliza
    def initialize
        @conversations = {}

    end

    def hear(user, message)
        @conversations[user] ||= Conversation.new(user)

        return @conversations[user].hear(message)
    end
end

class Conversation
    def initialize(user)
        @state = :start
        @user = user
    end

    def hear(message)
        @state, @reply = self.send(@state, message)

        return @reply
    end

    def start(message)
        @last_spoke = Time.now
        return :regreet, "Hello #{@user}! It is very nice to meet you. How can I help you today?"
    end

    def regreet(message)
        time = Time.now - @last_spoke
        @last_spoke = Time.now
        return :regreet, "Hello again #{@user}. We last spoke #{time} ago."
    end
end
