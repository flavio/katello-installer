begin
  prefix = ENV['KATELLO_GIT_CHECKOUT'] || '/usr/share/katello/'
  require "#{prefix}/lib/util/password"
rescue LoadError
  STDERR.puts "Katello was not installed on this host - passwords won't be encrypted"
  # define dummy encrypt functions that does nothing
  module Password
    def Password.encrypt(text); return text; end
  end
end

module Puppet::Parser::Functions
  system("/usr/share/katello/script/katello-generate-passphrase")

  newfunction(:katello_passencrypt, :type => :rvalue) do |args|
    return Password.encrypt(args[0])
  end

end
