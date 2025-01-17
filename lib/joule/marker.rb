module Joule
  class Marker
    include Joule::Hashable

    attr_accessor :active
    attr_accessor :average_cadence
    attr_accessor :average_heartrate
    attr_accessor :average_power
    attr_accessor :average_power_to_weight
    attr_accessor :average_speed
    attr_accessor :comment
    attr_accessor :duration_seconds
    attr_accessor :distance
    attr_accessor :end
    attr_accessor :energy
    attr_accessor :intensity_factor
    attr_accessor :maximum_cadence
    attr_accessor :maximum_heartrate
    attr_accessor :maximum_power
    attr_accessor :maximum_power_to_weight
    attr_accessor :maximum_speed 
    attr_accessor :normalized_power 
    attr_accessor :start
    attr_accessor :training_stress_score 


    def initialize(options = {})
      @active = true
      @average_cadence = 0
      @average_heartrate = 0
      @average_power = 0.0
      @average_power_to_weight = 0.0
      @average_speed = 0.0
      @comment = ""
      @duration_seconds = 0
      @distance = 0.0
      options[:end] ? @end = options[:end] : @end = 0
      @energy = 0
      @intensity_factor = 0
      @maximum_cadence = 0
      @maximum_heartrate = 0
      @maximum_power = 0.0
      @maximum_power_to_weight = 0.0
      @maximum_speed = 0.0
      @normalized_power = 0
      options[:start] ? @start = options[:start] : @start = 0 
      @training_stress_score = 0.0
    end

  end  
end


