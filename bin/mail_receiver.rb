ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'

require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
puts "Rails #{ENV['RAILS_ENV']} environment loaded."

require 'net/imap'
require 'net/http'

require "#{Rails.root}/app/mailers/parser"

# amount of time to sleep after each loop below
SLEEP_TIME = 300


# Fix standard date formats to comply with very strange errors
Time::DATE_FORMATS[:default] = '%m/%d/%Y %H:%M'
Date::DATE_FORMATS[:default] = '%m/%d/%Y'



# this script will continue running forever
loop do
  begin
    # make a connection to imap account
    imap = Net::IMAP.new(APP_CONFIG['mail']['imap']['host'], APP_CONFIG['mail']['imap']['port'], true)
    imap.login(APP_CONFIG['mail']['account']['user_name'], APP_CONFIG['mail']['account']['password'])
    # select inbox as our mailbox to process
    imap.select('Inbox')

    # get all emails that are in inbox that have not been deleted
    imap.uid_search(["NOT", "DELETED"]).each do |uid|
      # fetches the straight up source of the email for tmail to parse
      source = imap.uid_fetch(uid, ['RFC822']).first.attr['RFC822']

      Receiver.receive(source)

      # there isn't move in imap so we copy to new mailbox and then delete from inbox
      imap.uid_copy(uid, "Processats")
      imap.uid_store(uid, "+FLAGS", [:Deleted])
    end

    # expunge removes the deleted emails
    imap.expunge
    imap.logout
    imap.disconnect

  # NoResponseError and ByResponseError happen often when imap'ing
  rescue Net::IMAP::NoResponseError => e
    EMAIL_LOGGER.error("No response: #{e}")
  rescue Net::IMAP::ByeResponseError => e
    EMAIL_LOGGER.error("Bye response: #{e}")
  rescue => e
    EMAIL_LOGGER.error("Error: #{e}")
    puts e
    puts e.backtrace.join("\n")
  end

  # sleep for SLEEP_TIME and then do it all over again
  sleep(SLEEP_TIME)
end

