#!/usr/bin/env rspec

require 'spec_helper'

describe 'snmp' do
	
	let (:params) { { :syslocation => 'Hasselt' } }
	let (:params) { { :syscontact => 'unix@cegeka.be' } }

	#it { should contain_class 'snmp' }

	context "Operating system release 5.8" do
		it { should contain_class 'snmp' }

		let(:facts) { { :operatingsystemrelease => '5.8' } }
	
		it { should contain_service('snmpd').with_ensure('running') }

	  it { should contain_package('net-snmp').with_ensure('present') }

		it 'should create /etc/sysconfig/snmpd.options' do
      should contain_file('/etc/sysconfig/snmpd.options').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    end
	end

	context "Operating system release 6.2" do
		it { should contain_class 'snmp' }
		
		let(:facts) { { :operatingsystemrelease => '6.2' } }

		it { should contain_service('snmpd').with_ensure('running') }

	  it { should contain_package('net-snmp').with_ensure('present') }

		it 'should create /etc/sysconfig/snmpd' do
      should contain_file('/etc/sysconfig/snmpd').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    end
  end

  
#	context "Operating system release 5.8" do

#		let(:facts) { { :operatingsystemrelease => '5.8' } }

#		it 'should create /etc/sysconfig/snmpd.options' do
 #   	should contain_file('/etc/sysconfig/snmpd.options').with({
  #    	'ensure' => 'file',
   #   	'owner'  => 'root',
    #  	'group'  => 'root',
     # 	'mode'   => '0644',
   # 	})
 # 	end
#	end

#  it 'should create /etc/snmp/snmpd.conf' do
#    should contain_file('/etc/snmp/snmpd.conf').with({
#      'ensure' => 'file',
##			'owner'  => 'root',
 #     'group'  => 'root',
 #     'mode'   => '0644',
 #   })
 # end

  #it 'should create /etc/sysconfig/snmpd.options' do
  #  should contain_file('/etc/sysconfig/snmpd.options').with({
  #    'ensure' => 'file',
#			'owner'  => 'root',
#      'group'  => 'root',
#      'mode'   => '0644',
#    })
#  end
	
end
