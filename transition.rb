class Transition
    attr_accessor :symbol, :description, :event, :destination

    def initialize(symbol, description, event, destination)
        ['symbol', 'description', 'event', 'destination'].each do |var|
            eval("@#{var} = #{var}")
        end
    end
end
