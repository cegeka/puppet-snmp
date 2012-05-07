#!/usr/bin/env rspec

require 'spec_helper'

describe 'snmp' do
	
	let (:params) { { :syslocation => 'Hasselt' } }
	let (:params) { { :syscontact => 'unix@cegeka.be' } }
	
  it { should contain_class 'snmp' }

	it { should contain_service('snmpd').with_ensure('running') }

  it { should contain_package('net-snmp').with_ensure('present') }

  it 'should create /etc/snmp/snmpd.conf' do
    should contain_file('/etc/snmp/snmpd.conf').with({
      'ensure' => 'file',
			'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    })
  end

  it 'should create /etc/sysconfig/snmpd.options' do
    should contain_file('/etc/sysconfig/snmpd.options').with({
      'ensure' => 'file',
			'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    })
  end
	
end
