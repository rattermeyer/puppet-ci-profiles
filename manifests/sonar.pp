class profiles::sonar() {
  $sonar_jdbc = {
    url               => "jdbc:mysql://${ipaddress_eth0}:3306/sonar",
    username          => 'sonar',
    password          => 'sonar',
  }
  class { 'sonarqube' :
    version      => '4.3.2',
    user         => 'sonar',
    group        => 'sonar',
    service      => 'sonar',
    installroot  => '/usr/local',
    home         => '/var/local/sonar',
    download_url => 'http://dist.sonar.codehaus.org',
    jdbc         => $sonar_jdbc,
    log_folder   => '/var/local/sonar/logs',
    updatecenter => true,
    context_path => '/sonar',
    require  => Class['maven::maven'],
  }
  create_resources(sonarqube::plugin, hiera_hash('profile::sonar::plugins'), {'groupid' => 'org.codehaus.sonar-plugins', 'require' => Class['maven::maven']})
}
