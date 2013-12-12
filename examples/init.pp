class { 'snmp':
  syslocation => 'Location',
  syscontact  => 'test@maildomain.com',
}

snmp::config { 'hpsim':
  ensure            => present,
  additional_config => {
    'dlmod'         => 'cmaX /usr/lib64/libcmaX64.so',
    'trapcommunity' => 'trap',
    'trapsink'      => '127.0.0.1 trap'
  }
}

snmp::config { 'fsckro':
  ensure            => present,
  additional_config => {
    'exec'      => 'fsckro /usr/local/scripts/fsck-ro.rb'
  }
}
