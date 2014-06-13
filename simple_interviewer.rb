require 'engtagger'

class Interviewer
  def initialize
    @tagger = EngTagger.new
    @history = []
    @topics = []
  end

  def ask
    if @topics.empty?
      reply = prompt_for_new_topic
    else
      topic = @topics.pop
      reply = prompt("Tell me about #{topic}")
    end
    analyze_reply(reply)

    ask
  end

  def prompt(str)
    puts str
    reply = gets.chomp
    @history << reply
    reply
  end

  def prompt_for_new_topic
    prompt("What's on your mind?")
  end

  def analyze_reply(reply)
    tagged = @tagger.add_tags(reply)
    noun_phrases = @tagger.get_max_noun_phrases(tagged)
    p noun_phrases
    p noun_phrases.to_a
    @topics += noun_phrases.to_a.map {|x| x.first}
  end
end

int = Interviewer.new
int.ask
