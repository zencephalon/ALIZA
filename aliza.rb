require 'rubygems'
require 'bundler/setup'

require 'engtagger'
require 'yaml'
require 'engtagger'

class Aliza
    attr_accessor :name, :conversations

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
    attr_accessor :phrases, :first_time_teaching_hypnosis, :state, :user, :tagger

    def initialize(user, aliza, tagger)
        @state = :start
        @aliza = aliza
        @user = user
        @tagger = tagger
        @phrases = nil
        @first_time_teaching_hypnosis = nil
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
        if msg.match(@aliza.name)
            return :wait, "Hello #{@user}, well met! Try '#{@aliza.name}: help' to hear how I can help."
        else
            return :start, nil
        end
    end

    def wait(msg)
        if msg.match(@aliza.name)
            if msg.match('help')
                return :help, :continue
            end

            if msg.match('encourage')
                return :encourage, :continue
            end

            if msg.match('teach') && msg.match('hypnosis')
                return :teach_hypnosis, :continue
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
        @phrases ||= ["Compared to almost everyone, you have an interesting life!",
            "A journey of a thousand miles begins with one step.",
            "If it were easy it wouldn't be fun!",
            "You're in hackNY! You must be smart and tenacious.",
            "Look at how many friends you have in this channel that love you!",
            "You're far stronger than you know.",
            "Smile and breathe deeply. I promise you will feel better.",
            "Take a break. We need you to avoid burnout so you can save the world.",
            "You are an inspiration to me."]

        # Pick one at random, then delete it so we don't get repeats
        phrase = @phrases.delete(@phrases.sample)

        # This will cause @phrases ||= to set it to the array again the next time.
        @phrases = nil if phrase.nil?

        # Build the response
        phrase = "#{@user}: " + (phrase.nil? ? "I'm all out of encouragement, unless you want me to recycle." : phrase)

        return :wait, phrase
    end

    def teach_hypnosis(msg)
        @hypno_intro ||= false
        @hypno_phrases ||= [
            ["You may be aware of ___ as you ___.", "It's happening - it's just a matter of whether or not you're aware of it. Of course, if you really want to find out, you need to do what follows the 'as you'. You may be aware of the sound of my voice as you _slip into a flow state_. You may be aware of sensations in your body as you _relax even more deeply_. You may be aware of a sense of enjoyment as you _continue practicing these patterns_."],
            ["You may notice ___ as you ___.", "You may notice it, or you may not, but as you do whatever's been suggested, you'll probably be looking for it. You may _notice a sense of anticipation_ as you _start to relax_. You may _notice the sensations in your hands_ as you _allow yourself to go into flow_. You may _notice certain feelings_ as you become determined to _learn these patterns thoroughly_."],
            ["You might ___.", "You might do this or you might do that. I'm not telling you what to do, just what might transpire. You might start to _find a new way of perceiving this situation_. You might _see a new direction opening up in front of you_. You might _find yourself repeating these patterns as you sleep and dream_."],
            ["You might become aware of ___ when you ___.", "You might become aware of it, which presupposes it's already there, and all you have to do to find out, is the bit after the 'when you'. You might become aware of a deepening sense of flow when you _focus your attention inside yourself_. You might become aware of a new range of possibilities when you _allow your unconscious to start generating solutions_. You might become aware of an emerging sense of confidence as you _practice these patterns repeatedly_. It's just a possibility!"],
            ["Don't ___ too quickly.", "You're going to do it, it's just a matter of how quickly, and we wouldn't it to happen _too_ quickly, now, would we? It's better to savour it! Don't _go into a flow state_ too quickly. Don't close your eyes _too_ quickly. Don't _learn these patterns_ too quickly."],
            ["How does it feel when you ___?", "How does it feel? It's a fair question, and in order to find out, you have to at least imagine what I've asked. How does it feel when you _allow yourself to relax deeply_? How does it feel when you _get in touch with the part of your body that feels the best_? How does it feel when you _imagine using these patterns skillfully_?"]
        ]

        if !@hypno_intro
            @hypno_intro = true

            return :teaching_hypnosis, "#{@user}: I will give you the pattern, then some examples. Phrases in underscores are embedded commands, which you should speak with a descending intonation. Use tell me to 'continue' or 'quit'."
        else
            phrase = @hypno_phrases.delete(@hypno_phrases.sample)
            @hypno_phrases = nil if phrase.nil?

            return :teaching_hypnosis, "#{@user}: the pattern is\n" + phrase[0] + "\n" + phrase[1]
        end
    end

    def teaching_hypnosis(msg)
        if msg.match(@aliza.name)
            if msg.match('continue')
                return :teach_hypnosis, :continue
            elsif msg.match('quit')
                return :wait, "#{@user}: You may continue your lesson in the days and weeks ahead."
            else
                return :teaching_hypnosis, "#{@user}: I don't understand your request in this context. You can 'quit' or 'continue' your hypnosis lessons."
            end
        else
            return :teaching_hypnosis, nil
        end
    end

    def regreet(msg)
        time = Time.now - @last_spoke
        @last_spoke = Time.now
        return :regreet, "Hello again #{@user}. We last spoke #{time} ago."
    end
end
