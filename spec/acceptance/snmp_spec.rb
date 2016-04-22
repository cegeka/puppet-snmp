require 'spec_helper_acceptance'

describe 'snmp::init' do

  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        class { "snmp":
          syslocation       => 'Belgium',
          syscontact        => 'unix@example.com',
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file '/etc/snmp/snmpd.conf' do
      it { is_expected.to be_file }
      its(:content) { should match /Belgium/ }
      its(:content) { should match /unix@example.com/ }
    end

    describe service('snmpd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
