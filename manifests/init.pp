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
#   syslocation       => 'Belgium',
#   syscontact        => 'unix@example.com',
#   additional_config => {
#     "exec"           => "SCRIPT_NAME SCRIPT_FULL_PATH [ARGS ...]",
#     "extend"         => "OID COMMAND_FULL_PATH [ARGS ...]",
#   }
# }
#
class snmp($syslocation = '', $syscontact = '', $additional_config = '') {

  $snmpd_options_file = $::operatingsystemrelease ? {
    /^5.*$/ => '/etc/sysconfig/snmpd.options',
    /^6.*$/ => '/etc/sysconfig/snmpd',
  }

  package { ['net-snmp', 'net-snmp-utils'] :
    ensure  => present,
  }

  file { '/etc/snmp/snmpd.conf' :
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template("${module_name}/snmpd.conf.erb"),
    notify  => Service['snmpd'],
    require => Package['net-snmp'],
  }

  file { $snmpd_options_file :
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
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
