require 'open-uri'
require 'uri'
require 'set'

#
# Check against gigablast.
#
PlugMan.define :gigablastbyaddress do
  author "Alessandro Tanasi"
  version "0.2.0"
  extends({ :main => [:ip] })
  requires []
  extension_points []
  params({ :description => "Check against gigablast." })

  def run(ip, opts = {})
    hosts = Set.new

    begin
      page = open("http://www.gigablast.com/search?n=100&q=ip:#{ip}").read
    rescue OpenURI::HTTPError, Timeout::Error
      return hosts
    end
    
    page.scan(/<a href=(.*?)><font /).each do |url|
      begin
        hosts << { :hostname => URI.parse(url.to_s).host }
      rescue URI::InvalidURIError
        next
      end
    end

    return hosts
  end
end
