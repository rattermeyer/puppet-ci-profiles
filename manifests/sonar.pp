class profiles::sonar(
  $sonar_user = 'sonar',
  $sonar_group = 'sonar',
  $sonar_db = 'sonar',
  $sonar_db_user = 'sonar',
  $sonar_db_password = 'sonar',
  $sonar_jdbc = {
    url               => "jdbc:mysql://${ipaddress_eth0}:3306/sonar",
    username          => "${sonar_db_user}",
    password          => "${sonar_db_password}",
  },
  $sonar_version = '4.3.2'
) {
  mysql::db { "${sonar_db}":
      user     => $sonar_db_user,
      password => $sonar_db_password,
      host     => '%.%.%.%',
      grant    => ['ALL'],
  }
  mysql_grant { "${sonar_db_user}@%.%.%.%": 
    ensure => 'present',
    privileges => ['ALL'],
    table      => "${sonar_db_user}.*",
    user       => "${sonar_db_user}@%.%.%.%",
  }
  class { 'sonarqube' :
    version      => $sonar_version,
    user         => $sonar_user,
    group        => $sonar_group,
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
  create_resources(sonarqube::plugin, hiera_hash('profile::sonar::plugins'), {'require' => Class['maven::maven']})
}
