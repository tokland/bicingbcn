#!/usr/bin/ruby

require 'rubygems'
require 'open-uri'
require 'iconv'
require 'hpricot'

class Array
  # Convert  array to hash. The elements on the array 
  # must be (key, value) pairs 
  #
  # Example: 
  # 
  # >> [[1, 2], [3, 4]].to_hash
  # >> {1=>2, 3=>4}
  def to_hash
    h = {}
    each { |k, v| h[k] = v }
    h
  end
end

# BicingBCN is a simple module to interface Barcelona Bicing services:
#
# For now it only retrieves bikes occupations.
#
module BicingBCN
  MAP_URI = "http://www.bicing.cat/localizaciones/localizaciones.php"

  class Error < StandardError; end

  # Get hash containing information about Bicing stations.
  #
  # Options: 
  #   :map_uri: URI to map containing ML info
  #
  #   >> BicingBCN.occupations
  #   => {
  #        1 => {
  #         :bikes_available => 2,
  #         :bikes_total => 21,
  #         :coordinate_latitude => 41.397978,
  #         :coordinate_longitude => 2.180019,
  #         :name => "Gran Via de les Corts Catalanes 760",
  #        },
  #     ...
  #     ...
  #     }
  #
  def self.occupations(options = {})
    map_uri = File.join(options[:map_uri] || MAP_URI) 
    htmldata = open(map_uri).read
    kmldata = htmldata.match(/exml.parseString\('(.*)'\);/)[1]
    self.process_kml(kmldata)
  end 
  
  private
    
  def self.process_kml(kmldata)
    hpdata = Hpricot.parse(kmldata)
    stations = ((((hpdata/:kml).first)/:document).first)/:placemark
    stations.collect do |station|
      longitude, latitude, n = (station/:point).inner_text.split(",")
      description = Hpricot.parse(recode((station/:description).inner_text))
      complete_name = (description/:div)[1].inner_text
      index, name = complete_name.split("-").map(&:strip)
      occupation = (description/:div)[3]
      available, empty = occupation.children.values_at(0, 2).collect do |node|
        node.inner_text.to_i
      end
      info = {
        :name => name.gsub(/\\/, ''),
        :coordinate_longitude => longitude.to_f,
        :coordinate_latitude => latitude.to_f,
        :bikes_total => available + empty,
        :bikes_available => available,
      }
      [index.to_i, info]
    end.to_hash
  end  
  
  def self.recode(s, from="iso8859-15", to="utf-8")
    Iconv.conv(to, from, s)
  end
end
