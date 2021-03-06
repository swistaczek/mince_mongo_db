require_relative '../../../lib/mince_mongo_db/config'

describe MinceMongoDb::Config do
  it 'contains the primary key to used by the db interface' do
    described_class.primary_key.should == '_id'
  end

  it 'contains a database host' do
    described_class.database_host.should == '127.0.0.1'
  end

  it 'can change the database host' do
    original_host = described_class.database_host
    new_host = mock
    described_class.database_host = new_host
    described_class.database_host.should == new_host

    described_class.database_host = original_host
  end

  describe 'the database name' do
    subject { described_class.database_name }

    it 'by default is "mince"' do
      subject.should == 'mince'
    end

    it 'can be explicitly defined' do
      described_class.database_name = 'custom_db_name'

      subject.should == 'custom_db_name'

      # Change name back because it is a singleton object
      described_class.database_name = 'mince'
    end

    context 'when running parallel tests' do
      before do
        # Stubbing described_class because the method gets value from an environment
        # variable, which is dangerous to change inside of a test and dangerous to
        # stub
        described_class.stub(:test_env_number => '1')

        # Change name so that the test number is appended
        described_class.database_name = 'mince'
      end

      it 'appends the test number to the db name' do
        subject.should == 'mince-1'
      end
    end
  end

  it 'does not contain a username' do
    described_class.username.should be_nil
  end

  it 'can change the database username' do
    new_username = mock
    described_class.username = new_username
    described_class.username.should == new_username

    described_class.username = nil
  end

  it 'does not contain a password' do
    described_class.password.should be_nil
  end

  it 'can change the database password' do
    new_password = mock
    described_class.password = new_password
    described_class.password.should == new_password

    described_class.password = nil
  end

  it 'can return all writable options' do
    described_class.options.should == {
      database_name: described_class.database_name,
      database_host: described_class.database_host,
      username: described_class.username,
      password: described_class.password
    }
  end

  it 'can change the options by passing a hash' do
    original_options = described_class.options
    new_options = {
      database_name: 'new_database_name',
      database_host: mock,
      username: mock,
      password: mock      
    }
    described_class.options = new_options
    described_class.options.should == new_options

    described_class.options = original_options
  end

  it 'can change a select number of the options by passing a hash' do
    original_options = described_class.options
    new_options = {
      database_name: 'new_database_name',
      database_host: mock
    }
    described_class.options = new_options
    described_class.options.should == original_options.merge(new_options)

    described_class.options = original_options
  end

  it 'does not allow assigning unacceptable options' do
    original_options = described_class.options
    new_options = {
      foo: 'foo'
    }
    described_class.options = new_options
    described_class.options.should == original_options

    described_class.options = original_options
  end
end
