require 'rubygems'
require 'bundler/setup'

require 'engtagger'
require 'yaml'

class Aliza
    attr_accessor :name

    def initialize(name)
        @conversations = {}
        @name = name
    end

    def hear(user, msg)
        @conversations[user] ||= Conversation.new(user, self)

        return @conversations[user].hear(msg)
    end
end

class Conversation
    def initialize(user, aliza)
        @state = :start
        @aliza = aliza
        @user = user
    end

    def hear(msg)
        @state, @reply = self.send(@state, msg)

        while @reply == :continue
            @state, @reply = self.send(@state, msg)
        end

        return @reply
    end

    def help(msg)
        return :wait, "#{@user}: I'm still pretty useless right now, sorry!"
    end

    def start(msg)
        @last_spoke = Time.now
        return :wait, "Hello #{@user}, well met! Try '#{@aliza.name}: help' to hear how I can help."
    end

    def wait(msg)
        if msg.match(@aliza.name)
            if msg.match('help')
                return :help, :continue
            end
        else
            return :wait, nil
        end
    end

    def regreet(msg)
        time = Time.now - @last_spoke
        @last_spoke = Time.now
        return :regreet, "Hello again #{@user}. We last spoke #{time} ago."
    end
end
