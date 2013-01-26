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
