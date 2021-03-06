module Slosilo
  unless defined? LEGACY_WARNED
    puts """
      WARNING!! You are loading compatibility Slosilo code. It has known potential
      security problems and is deprecated; this code is ONLY meant to be used in
      migrations and tests.

      First loaded from:
    """
    puts caller.map{|s| "\t\t#{s}"}
    LEGACY_WARNED = true
  end
end

require 'slosilo/migration/symmetric'
require 'slosilo/migration/migrate_keys'
require 'slosilo/migration/attr_encrypted'
