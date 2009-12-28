require File.dirname(__FILE__) + '/helper'

module Joule
  class TestTcxParser < Joule::TestCase

    def test_parse_with_power()
      xml = IO.read(TCX_FILE_WITH_POWER)
      tcx_parser = TcxParser.new(xml)
      tcx_parser.parse(:calculate_marker_values => true)
      data_points = tcx_parser.data_points
      
      assert_equal 3410, data_points.size 
      assert_equal 3409, data_points.last.time
      assert_equal 3479, data_points.last.time_with_pauses
      assert_equal 66426, data_points.last.time_of_day     
    end

    def test_parse_with_calculate_maker_values
      xml = IO.read(TCX_FILE_WITH_POWER)
      tcx_parser = TcxParser.new(xml)
      tcx_parser.parse(:calculate_marker_values => true)
      
      assert_equal 1, tcx_parser.markers.size 
      assert_equal 150, tcx_parser.markers.first.average_power
      assert_equal 66, tcx_parser.markers.first.average_cadence
      assert_equal 12.8, sprintf("%.1f", tcx_parser.markers.first.distance * 0.0000006214).to_f
      assert_equal " 0:56:50", Time.at(tcx_parser.markers.first.duration_seconds).utc.strftime("%k:%M:%S")
      assert_equal 511, tcx_parser.markers.first.energy
    end
    
    def test_parse_without_calculate_maker_values
      xml = IO.read(TCX_FILE_WITH_POWER)
      tcx_parser = TcxParser.new(xml)
      tcx_parser.parse(:calculate_marker_values => false)
      
      assert_equal 0, tcx_parser.markers.first.average_power
    end
    
    def test_parse_without_calculate_peak_power_values
      xml = IO.read(TCX_FILE_WITH_POWER)
      tcx_parser = TcxParser.new(xml)
      tcx_parser.parse(:calculate_peak_power_values => false)
      
      assert_equal 0, tcx_parser.peak_powers.size
    end
    
    
    
    
    # 
    # def test_parse_with_power_and_multiple_laps()      
    #   xml = IO.read('files/2009-12-01-15-26-32.tcx')
    #   tcx_parser = TcxParser.new(xml)
    #   tcx_parser.parse  
    #   data_points = tcx_parser.data_points
    #   
    #   assert_equal 9619, data_points.size 
    # end

    # def test_parse_with_speed()
    #   xml = IO.read('files/activity_8755231.tcx')
    #   tcx_parser = TcxParser.new(xml)
    #   tcx_parser.parse  
    #   data_points = tcx_parser.data_points
    #   
    #   assert_equal 17734, data_points.size 
    # end


  end
end