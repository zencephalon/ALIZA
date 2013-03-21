require 'cinch'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.nick = "ALIZA"
    c.channels = ["#hackny"]
  end

  on :message, /.*/ do |m|
    m.reply "#{m.user.nick}, you said, #{m.message}"
  end
end

bot.start
