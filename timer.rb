require 'net/http'
require 'digest/md5'
require 'uri'

User = 'rayko'
Pass = Digest::MD5.hexdigest('53236815')

Host = 'dinamico.cdmon.org' # The web server
Path = '/onlineService.php?enctype=MD5&n=' + User + '&p=' + Pass

Timer_ok = 1800
Timer_fail = 15

def updateIP
  begin
    http = Net::HTTP.new(Host)          # Create a connection
    headers, body = http.get(Path)      # Request the file
    if headers.code == "200"            # Check the status code   
      # print Time.now.to_s + " OK - " + body + "\n"                        
      File::open("/var/log/IPupdate-log.txt", "a") do |sal|  sal << Time.now.to_s + " - OK - " + body + "\n" end
      return Timer_ok
    else                                
      # puts Time.now.to_s + " FAIL - #{headers.code} #{headers.message} \n" 
      File::open("/var/log/IPupdate-log.txt", "a") do |sal|  sal << Time.now.to_s + " - FAIL - #{headers.code} #{headers.message} \n" end
      return Timer_fail
    end
  rescue => e
    File::open("/var/log/IPupdate-log.txt", "a") do |sal|  sal << Time.now.to_s + " - FAIL - Conection time out or no active conection\n" end
    return Timer_fail
  end
end

while true do
   sleep(updateIP)
end 
