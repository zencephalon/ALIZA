require 'cinch'
load "aliza.rb"

aliza = Aliza.new

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.nick = "ALIZA"
    c.channels = ["#hackny"]
  end

  on :message, /hello/ do |m|
    m.reply aliza.hear(m.user.nick, m.message)
  end
end

bot.start
