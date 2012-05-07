#!/usr/bin/env rspec

require 'spec_helper'

describe 'snmp' do
  it { should contain_class 'snmp' }
end
