require 'rubygems'
require 'bundler/setup'

require 'engtagger'
require 'yaml'
require 'engtagger'

class Aliza
    attr_accessor :name

    def initialize(name)
        @conversations = {}
        @name = name
        @tagger = EngTagger.new
    end

    def hear(user, msg)
        @conversations[user] ||= Conversation.new(user, self, @tagger)

        return @conversations[user].hear(msg)
    end
end

class Conversation
    def initialize(user, aliza, tagger)
        @state = :start
        @aliza = aliza
        @user = user
        @tagger = tagger
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
                return :encourage, :continue
            end

            return :ask_subject, :continue
        else
            return :wait, nil
        end
    end

    def ask_subject(msg)
        msg = msg.gsub("#{@aliza.name}:", '')
        tagged = @tagger.add_tags(msg)
        noun_phrases = @tagger.get_max_noun_phrases(tagged)

        return :wait, "Tell me about #{reflect_pronouns(noun_phrases.keys[0])}."

    end

    def reflect_pronouns(s)
        k = s.clone

        swaps = {
            "your" => "my",
            "Your" => "My",
            "my" => "your",
            "My" => "Your",
        }

        swaps.each do |search, replace|
            k = k.gsub(/#{search} /, replace + "UGLYHACK ")
        end
        k.gsub("UGLYHACK", "")
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
