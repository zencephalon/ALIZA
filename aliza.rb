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
        return :wait, "#{@user}: Try '#{@aliza.name}: encourage'!"
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
            if msg.match('encourage')
                return :encourage, :continue;
            end
        else
            return :wait, nil
        end
    end

    def encourage(msg)
        phrases = ["Compared to almost everyone, you have an interesting life!",
            "A journey of a thousand miles begins with one step.",
            "If it were easy it wouldn't be fun!",
            "You're in hackNY! You must be smart and tenacious.",
            "Look at how many friends you have in this channel that love you!",
            "You're far stronger than you know.",
            "Smile and breathe deeply. I promise you will feel better.",
            "Take a break. We need you to avoid burnout so you can save the world.",
            "You are an inspiration to me."]

        return :wait, "#{@user}: " + phrases.sample(1)[0]
    end

    def regreet(msg)
        time = Time.now - @last_spoke
        @last_spoke = Time.now
        return :regreet, "Hello again #{@user}. We last spoke #{time} ago."
    end
end
