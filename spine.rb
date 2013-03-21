class Spine
    attr_accessor :state, :states, :transitions, :events, :event

    def initialize
        @state = :new
        @states = [:new, :ask_name]
        @events = [:initialize]
        @event = nil

        @transitions = [Transition.new(:initialize, 'A new Aliza is created.', :initialize, :ask_name)]

    end


    def execute
        if @event.nil?
            self.receive_event(:initialize)
        end

    end

end
