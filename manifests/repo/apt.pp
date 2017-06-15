class puppet::repo::apt {
  apt::source { 'puppetlabs':
    location    => 'http://apt.puppetlabs.com',
    repos       => 'main',
    key         => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
    key_server  => 'pgp.mit.edu',
  }
}
