class CuttlefishLogDaemon
  def self.start(file)
    begin
      while true
        if File.exists?(file)
          File::Tail::Logfile.open(file) do |log|
            log.tail do |line|
              PostfixLogLine.transaction do
                log_line = PostfixLogLine.create_from_line(line)
                # Check if an email needs to be blacklisted
                if log_line && log_line.status == "hard_bounce"
                  # We don't want to save duplicates
                  if BlackList.find_by(team_id: log_line.delivery.app.team_id, address: log_line.delivery.address).nil?
                    BlackList.create(team_id: log_line.delivery.app.team_id, address: log_line.delivery.address, caused_by_delivery: log_line.delivery)
                  end
                end
              end
            end
          end
        else
          sleep(10)
        end
      end
    rescue SignalException => e
      if e.to_s == "SIGTERM"
        puts "Received SIGTERM. Shutting down..."
      else
        raise e
      end
    end
  end
end
