# Make sure we show the warning
require 'slosilo/migration'

module Slosilo
  module Migration
    module MigrateKeys
      DEFAULT_KEYSTORE_TABLE = :slosilo_keystore

      attr_writer :keystore_table

      def keystore_table
        @keystore_table ||= DEFAULT_KEYSTORE_TABLE
      end

      def upgrade! db
        keystore = db[keystore_table]
        return unless keystore.count > 0

        key = Slosilo::encryption_key
        if key.nil?
          warn "Slosilo::encryption_key not set, assuming unencrypted key store"
          return
        end


        old_cipher = Slosilo::Migration::Symmetric.new
        new_cipher = Slosilo::Symmetric.new


        progress = progress_bar keystore.count

        keystore.each  do |row|
          begin
            # try to decrypt using new cipher
            new_cipher.decrypt row[:key], key: key, aad: row[:id]
            # it worked, no need to update
          rescue
            # otherwise, needs to be upgraded.
            ptext = old_cipher.decrypt row[:key], key: key
            ctext = new_cipher.encrypt ptext, key: key, aad: row[:id]
            keystore.where(id: row[:id]).update(key: Sequel.blob(ctext))
          end
          progress.increment
        end
      end


      def progress_bar count
        begin
          require 'ruby-progressbar'
          ProgressBar.create total: count, output: $stderr, format: '%t |%w>%i| %e'
        rescue LoadError
          Object.new.tap do |o|
            def o.increment; $stderr << '.' end
          end
        end
      end

    end
  end
end

# Usage:
# require 'slosilo/migration/migrate_keys'
# Sequel.migration do
#    up do
#     extend Slosilo::Migration::MigrateKeys
#     self.keystore_table = :some_custom_table
#     upgrade! self
#   end
#
#   down do
#     raise "Irreversible!"
#   end
# end
#
