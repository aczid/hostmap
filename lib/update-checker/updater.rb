require 'open-uri'
require 'rexml/document'


#
# Provides updates features.
#
module Updates

  #
  # Checks for new releases of a software.
  #
  class Checker

    #
    # URL where updates are located.
    #
    URL = "http://update.lonerunners.net"

    def initialize(software)
      @software = software
      @updates = {}
    end

    #
    # Checks if updates are available.
    #
    def check(version="0.0")
      @version = version
      if parseFeed(getFeed)
        return @updates
      else
        return false
      end
    end

    private

    def compare(version)
      this_ver = @version.split('.').map{|s|s.to_i}
      new_ver = version.to_s.split('.').map{|s|s.to_i}
      return true if (this_ver <=> new_ver) < 0
    end

    def getFeed
      begin
        open("#{URL}/softwares/latest/#{@software}", 'User-Agent' => "#{@software}-#{@version}").read
      rescue
        nil
      end
    end

    def parseFeed(data)
      doc = REXML::Document.new(data)
      doc.elements.each('softwares/software') do |ele|
        # Checks the software we want to update
        if ele.attributes['name'] == @software
          ele.elements.each('release') do |rel|
            if compare(rel.attributes['version'])
              rel.elements.each('package') do |pkg|
                @updates[pkg.elements['filename'].text] = pkg.elements['link'].attributes['href']
              end
              return true
            end
          end
        else
          return false
        end
      end
    end
  end
end