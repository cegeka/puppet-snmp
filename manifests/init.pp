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
# }
#
class snmp($syslocation = '', $syscontact = '') {

  $snmpd_options_file = '/etc/sysconfig/snmpd'
  $traphost = lookup('profile::iac::baremetal::traphost')

  package { ['net-snmp', 'net-snmp-utils'] :
    ensure  => present,
  }

  file { '/etc/snmp/snmpd.conf' :
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template("${module_name}/etc/snmp/snmpd.conf.erb"),
    notify  => Service['snmpd'],
    require => Package['net-snmp'],
  }

  file { '/etc/snmp/include':
    ensure  => directory,
    owner   => root,
    group   => root,
    mode    => '0750',
    require => Package['net-snmp'],
  }

  file { '/etc/init.d/snmpd' :
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    source  => "puppet:///modules/${module_name}/etc/init.d/snmpd",
    notify  => Service['snmpd'],
    require => Package['net-snmp'],
  }
  if $::operatingsystemmajrelease == "7" {
    file { $snmpd_options_file :
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => "puppet:///modules/${module_name}/etc/sysconfig/snmpd7",
      notify  => Service['snmpd'],
      require => Package['net-snmp'],
    }
    file { '/usr/lib/systemd/system/snmpd.service' :
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0444',
      source  => "puppet:///modules/${module_name}/snmpd.service",
      notify  => Exec['reload_systemctl'],
      require => Package['net-snmp'],
    }
    exec { 'reload_systemctl':
      command     => "systemctl daemon-reload",
      onlyif      => "test -x /usr/bin/systemctl",
      path        => ['/usr/bin', '/bin'],
      refreshonly => true,
      notify      => Service['snmpd']
    }
  } else {
    file { $snmpd_options_file :
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => "puppet:///modules/${module_name}/etc/sysconfig/snmpd",
      notify  => Service['snmpd'],
      require => Package['net-snmp'],
    }
  }

  service { 'snmpd' :
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
    require     => [Package['net-snmp'],File['/etc/snmp/include']],
  }

}
