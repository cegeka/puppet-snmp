# Class: snmp
#
# This module manages snmp
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
# class { "snmp":
#   syslocation => 'Hasselt',
#   syscontact  => 'unix@example.com',
# }
#
class snmp($syslocation = '', $syscontact = '') {

  package { 'net-snmp' :
    ensure  => present,
  }

  file { '/etc/snmp/snmpd.conf' :
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template("${module_name}/snmpd.conf.erb"),
    notify  => Service['snmpd'],
    require => Package['net-snmp'],
  }

  file { '/etc/sysconfig/snmpd.options' :
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0640',
    source  => "puppet:///modules/${module_name}/snmpd.options",
    notify  => Service['snmpd'],
    require => Package['net-snmp'],
  }

  service { 'snmpd' :
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
    require     => Package['net-snmp'],
  }

}
