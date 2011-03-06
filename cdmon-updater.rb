require 'net/http'
require 'digest/md5'
require 'uri'


class CdmonUpdater
  attr_accessor :log, :settings, :messages, :timer

  def initialize logger=nil, settings=nil
    self.log = logger
    self.settings = settings
  end

  def update_ip
    set_ok_timer
    begin
      http = Net::HTTP.new(self.settings[:updater][:host])
      headers, body = http.get(generate_path)
      if headers.code == "200"
        self.log.info 'Request OK 200'
        result = parse_response body
        if !result[:error]
          self.log.info result[:message]
        else
          self.log.error result[:message]
          set_fail_timer
        end
      else
        self.log.error "FAIL - Server response error - #{headers.code} - #{headers.message}"
        set_fail_timer
      end
    rescue => e
      self.log.error "FAIL - Connection issue. Cannot connect with server. #{e}"
      set_fail_timer
    end
    return self.timer
  end

  def generate_path
    "#{self.settings[:updater][:path]}?enctype=MD5&n=#{self.settings[:account][:user]}&p=#{Digest::MD5.hexdigest(self.settings[:account][:pass])}"
  end

  def parse_response r
    parsed_result = { }
    r.split('&').select{ |i| !i.empty?}.each do |var|
      parsed_result[var.split('=')[0]] = var.split('=')[1]
    end
    if parsed_result['resultat'] == 'guardatok'
      result = {:message => "Update OK. New IP: #{parsed_result['newip']}", :error => false}
    elsif parsed_result['resultat'] == 'customok'
      result = {:message => "Custom update OK.", :error => false}
    elsif parsed_result['resultat'] == 'badip'
      result = {:message => "Invalid IP", :error => true}
    elsif parsed_result['resultat'] == 'errorlogin'
      result = {:message => "Login data is incorrect. Cannot update.", :error => true}
    elsif parsed_result['resultat'] == 'novaversio'
      result = {:message => "There is a new version of the API. Check CDMon site for more info.", :error => true}
    end
    return result
  end

  def set_fail_timer
    self.timer = self.settings[:timer][:fail]
  end

  def set_ok_timer
    self.timer = self.settings[:timer][:ok]
  end
end
