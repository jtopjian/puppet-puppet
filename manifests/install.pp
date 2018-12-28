# == Class: puppet::install
#
# Installs the required puppet packages
#
class puppet::install {

  # Install Agent
  package { 'puppet':
    ensure => $::puppet::puppet_package_ensure,
    name   => $::puppet::puppet_package_name,
  }

  if $::puppet::server {
    notify { 'Install server': }
    package { 'puppetserver':
      ensure => $::puppet::server_package_ensure,
      name   => $::puppet::server_package_name,
    }
  }

}
