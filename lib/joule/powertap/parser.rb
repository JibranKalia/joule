module Joule
  module PowerTap
    class Parser < Joule::CSV::Parser
      MINUTES = 0
      TORQUE = 1
      SPEED = 2
      POWER = 3
      DISTANCE = 4
      CADENCE = 5
      HEARTRATE = 6
      MARKER = 7

      def parse_properties()
        header = FasterCSV.parse(@data).shift
        records = FasterCSV.parse(@data) 
        @workout.properties = Joule::PowerTap::Properties.new
        @workout.properties.speed_units = header[SPEED].to_s.downcase
        @workout.properties.power_units = header[POWER].to_s.downcase
        @workout.properties.distance_units = header[DISTANCE].to_s.downcase
        calculate_record_interval(records)
      end
      
      private
      def parse_data_points()
        records = FasterCSV.parse(@data) 
        records.shift

        records.each { |record|
          data_point = DataPoint.new
          data_point.time  = (record[MINUTES].to_f * 60).to_i
          data_point.torque = record[TORQUE].to_f
          data_point.speed = convert_speed(record[SPEED].to_f)
          data_point.power = record[POWER].to_f
          data_point.distance = convert_distance(record[DISTANCE].to_f)
          data_point.cadence = record[CADENCE].to_i
          data_point.heartrate = (record[HEARTRATE].to_i < 0) && 0 || record[HEARTRATE].to_i

          @workout.data_points << data_point
        }  
      end

      def parse_markers
        records = FasterCSV.parse(@data) 
        records.shift
        @workout.markers << create_workout_marker(records)

        current_marker_index = 0

        records.each_with_index { |record, index|
          if(record[MARKER].to_i > current_marker_index )
            create_marker(index)
            current_marker_index = current_marker_index + 1
          end 
        }

        #set the end of the last marker
        set_previous_marker_end(records.size - 1)  
      end

      def create_marker(start)
        if(@workout.markers.size.eql?(1))
          @workout.markers << Marker.new(:start => 0)
        end  
        set_previous_marker_end(start - 1)
        @workout.markers << Marker.new(:start => start)
      end

      def set_previous_marker_end(value)
        if(@workout.markers.size > 1)
          @workout.markers.last.end = value
        end
      end

      def calculate_record_interval(records)
        times = Array.new
        records[1..30].each_slice(2) {|s| times << ((s[1][MINUTES].to_f - s[0][MINUTES].to_f)  * 60) }
        @workout.properties.record_interval = times.average.round
      end

    end
    
  end
end