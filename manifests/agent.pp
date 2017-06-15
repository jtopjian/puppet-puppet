class puppet::agent (
  $settings,
  $config_file    = $::puppet::params::config_file,
  $service_mode   = 'daemon',
  $service_enable = true,
) inherits puppet::params {

  $settings.each |$setting, $value| {
    ini_setting { "${config_file} agent/${setting}":
      ensure  => present,
      path    => $config_file,
      section => 'agent',
      setting => $setting,
      value   => $value,
      tag     => 'puppet-config',
      require => Package['puppet'],
    }
  }

  if $service_mode == 'daemon' {
    Ini_setting <| tag =='puppet-config' |> ~> Service['puppet']
    if $service_enable {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'puppet':
      ensure   => $service_ensure,
      enable   => $service_enable,
      provider => 'init',
      require  => Package['puppet'],
    }

    case $::lsbdistid {
      'Ubuntu': {
        file { '/etc/default/puppet':
          ensure => present,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
        }

        file_line { '/etc/default/puppet START':
          path    => '/etc/default/puppet',
          line    => 'START=yes',
          match   => '^START=',
          require => [Package['puppet'], File['/etc/default/puppet']],
        }
      }
    }

  }

}
