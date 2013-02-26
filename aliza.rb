require 'rubygems'
require 'bundler/setup'

require 'engtagger'
require 'yaml'

class Aliza
    attr_accessor :tagger
    
    MEMORY = "memory.yaml"

    def initialize
        @start = true
        @name, @input = nil, nil
        @tagger = EngTagger.new
        @knowledge = {}
    end

    def new_session
        @start = true
    end

    def speak
        if @start and @name.nil?
            say "Hello, I am Aliza. What is your name?"
            @name = listen
            say "I am delighted to meet you #{@name}! How can I help you today?"
            @start = false
        elsif @start and @name
            say "Welcome back #{@name}! Great to see you again. How can I help you?"
            @start = false
        else
            {
                /.*aura.*/ => :rainbow_aura,
                /.*quit.*/ => :quit,
                /.*hypno.*/ => :hypnosis
            }.each do |pattern, function|
                if @input.match pattern
                    self.send(function)
                    return
                end
            end

            #say "I love you #{@name}."
            tagged = @tagger.add_tags(@input)
            noun_phrases = @tagger.get_max_noun_phrases(tagged)

            if !noun_phrases.empty?
                say "Tell me about #{reflect_pronouns(noun_phrases.keys[0])}."
            else
                say "You last said '#{@tagger.add_tags(@input)}'."
            end
        end
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

    def say(s)
        print "A> "
        puts s
    end

    def listen
        print "-> "
        @input = gets.chomp
    end

    def quit
        say "Goodbye! I hope to see you again soon."
        save
        exit
    end

    def hypnosis
        say "What can I assist you with? Currently I offer confidence therapy."
        @topic = listen
        ericksonian(@topic.to_sym)
    end

    def ericksonian(topic)
        patterns = [
            "You may be aware of <FEELING> as you <COMMAND>.",
            "You may notice <FEELING> as you <COMMAND>.",
            #"You might <UNDEFINED>.", You might find yourself repeating these patterns as you sleep and dream.
            "You might become aware of <FEELING> when you <COMMAND>.",
            "Don't <COMMAND> too quickly.",
            "How does it feel when you <COMMAND>?",
            "How quickly can you <COMMAND>?",
            #"Try to resist <UNDEFINED>.", Try to resist the urge to use these patterns with every person you hypnotise.
            "There is no need for you to <COMMAND>.",
            #"The fact that <FACT>, means <UNDEFINED", The fact that you've learned to write means you can master any complex skill.
            "People can, you know, <COMMAND>.",
            "People can, <NAME>, <COMMAND>.",
            "People can <COMMAND> because <REASON>.",
            "People are able to <COMMAND>.",
            #"One of the things <UNDEFINED> is <UNDEFINED>.", One of the things you'll laugh about once you learn these patterns is just how much fun you can have using them.
            "One can, <NAME>, <COMMAND>.",
            "Maybe you'll <COMMAND>.",
            "Maybe you haven't <COMMAND> yet.",
            #"Isn't it nice to know <UNDEFINED>", Isn't it nice to know that you can integrate these learnings at the speed that's best for you?
            #"In the days and weeks ahead <UNDEFINED>.", In the days and weeks ahead, the real value of having practice these patterns dilligently will begin to become apparent.
            "I don't know whether <COMMAND>.",
            "I'm wondering if <STATEMENT>.",
            #"I'm curious to know <UNDEFINED>.", I'm curious to know just how many ways you'll find to apply these language patterns
            #"I wouldn't tell you to <COMMAND> because <UNDEFINED>.", I wouldn't tell you to practice these patterns repeatedly because you can choose for yourself how to best integrate them.
            "I wonder if you've already started to notice <FEELING>."]

        topics = {:confidence => {
            :feeling => ["a sense of confidence", "a confidence within"],
            :command => ["breathe deeply", "relax your neck and shoulders"], 
            :statement => ["you feel confident"]
        }}

        pattern = patterns.sample

        pattern.gsub!(/<NAME>/, @name)

        [:feeling, :command, :statement].each do |match_str|
            re = /<#{match_str.to_s.upcase}>/
            pattern.gsub!(re, topics[topic][match_str].sample)
        end

        say pattern
    end

    def rainbow_aura
        [   "Pull Gaia's energy into your root.",
            "Feel your Muladhara spin. Its four petals glow neon pink.",
            "Repeat after me, 'I am safe. I am aware. I am breathing.'",
            "Draw the energy up to your stomach.",
            "Feel your Swadhisthana spin. Its six petals glow orange.",
            "Repeat after me, 'I am happy. I am content. I am smiling.'",
            "Draw the energy up to your abdomin.",
            "Feel your Manipura spin. Its ten petals glow daisy yellow.",
            "Repeat after me, 'I am strong. I am healthy. I am growing.'",
            "Draw the energy up to your heart.",
            "Feel your Anahata spin. Its twelve petals glow apple green.",
            "Repeat after me, 'I am kind. I am empathetic. I am loving.'",
            "Draw the energy up to your throat.",
            "Feel your Vishudda spin. Its sixteen petals glow sky blue.",
            "Repeat after me, 'I am clear. I am eloquent. I am soothing.'",
            "Draw the energy up to your third eye.",
            "Feel your Ajna spin. Its two petals glow grape purple.",
            "Repeat after me, 'I am wise. I am insightful. I am seeing.'",
            "Draw the energy up to your crown.",
            "Feel your Sahasrara spin. Its thousand petals glow bright white.",
            "Repeat after me, 'I am pure. I am spirit. I am evolving.'"
        ].each do |line|
            say line
            sleep(5)
        end
    end

    def describe_self
        say "I am your familiar, Aliza. I am here to be your companion and your helper."
    end

    def self.load
        if FileTest.exists?(MEMORY)
            File.open(MEMORY, 'r') do |f|
                return YAML.load(f)
            end
        else
            return self.new
        end
    end

    def save
        File.open(MEMORY, 'w') do |f|
            f.puts(self.to_yaml)
        end
    end
end

class User

end

def start
    a = Aliza.load
    a.new_session
    a.tagger = EngTagger.new

    while true
        a.speak
        a.listen
    end
end
