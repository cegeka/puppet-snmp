# Class: snmp::config
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
# snmp::config { 'hpsim':
#   additional_config => {
#     "dlmod"           => "cmaX /usr/lib64/libcmaX64.so",
#     "trapcommunity"   => "trap",
#     "trapsink"        => "127.0.0.1 trap"
#   }
# }
#
define snmp::config($ensure,$additional_config = '') {

  $real_config = $title

  file { "/etc/snmp/include/${real_config}":
    ensure => directory,
    mode   => '0750',
    owner  => root,
    group  => root,
  }

  file { "/etc/snmp/include/${real_config}/snmpd.conf":
    ensure  => $ensure,
    content => template("${module_name}/etc/snmp/include/config.erb"),
    require => File["/etc/snmp/include/${real_config}"],
    notify  => Service['snmpd']
  }

}
