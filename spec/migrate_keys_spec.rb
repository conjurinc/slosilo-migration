require 'spec_helper'

class Object
  def metaclass
    class << self; self; end
  end
end

describe Slosilo::Migration::MigrateKeys do

  subject { Class.new.extend(Slosilo::Migration::MigrateKeys) }

  context 'for rows already encrypted properly' do

    before(:each) { Slosilo::encryption_key = 'bed3033f87d71911a357cebe35ecb434' }

    let (:row_id) { 'id' }
    let (:db) {
      encrypted_key = Slosilo::Symmetric.new.encrypt('foo', :key => Slosilo::encryption_key, :aad => row_id )
      
      # Match the shape of the keystore object expected by MigrateKeys#upgrade!
      {
        Slosilo::Migration::MigrateKeys::DEFAULT_KEYSTORE_TABLE => [
          {:key => encrypted_key, :id => row_id }
        ]
      }
    }
  
    it 'ignores them' do
      expect { subject.upgrade!(db) }.not_to raise_exception
    end

  end
  
end
