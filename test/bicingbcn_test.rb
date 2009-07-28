#!/usr/bin/ruby

require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/bicingbcn')

class BicingBCNTest < Test::Unit::TestCase
  def test_occupations
    htmlfile = File.join(File.dirname(__FILE__), 'localizaciones.php')
    info = BicingBCN.occupations(:map_uri => htmlfile)    
    assert_equal(412, info.size, "Occupations hash size invalid") 
    assert_equal({   
      :bikes_available => 11,
      :bikes_total => 16,
      :coordinate_latitude => 41.397978,
      :coordinate_longitude => 2.180019,
      :name => "Gran Via Corts Catalanes",
    }, info[1], "First station invalid")
  end
end
