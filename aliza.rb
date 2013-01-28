class Aliza
   def initialize
       @start = true
       @name, @input = nil, nil
   end

   def speak
       if @start
           say "Hello, I am Aliza. What is your name?"
           @name = listen
           say "I am delighted to meet you #{@name}! How can I help you today?"
           @start = false
       else
           if @input.match /.*aura.*/
               rainbow_aura
           else
               say "I love you #{@name}."
               say "You last said '#{@input}'."
           end
       end
   end

   def say(s)
       print "A> "
       puts s
   end

   def listen
       print "-> "
       @input = gets.chomp
   end

   def ericksonian
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
end

a = Aliza.new

while true
    a.speak
    a.listen
end
