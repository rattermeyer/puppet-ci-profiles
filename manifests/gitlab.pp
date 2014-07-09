class profiles::gitlab() {
  mysql::db { 'gitlabhq_production':
      user     => 'gitlab',
      password => 'password',
      host     => '%.%.%.%',
      grant    => ['ALL'],
      charset  => 'utf8',
      collate  => 'utf8_unicode_ci'
  }
  mysql_grant { 'gitlab@%.%.%.%': 
    ensure => 'present',
    privileges => ['ALL'],
    table      => 'gitlab.*',
    user       => 'gitlab@%.%.%.%',
  }
  file { ['/opt/gitlab', '/opt/gitlab/data'] :
    ensure  => 'directory',
  }->
  exec { 'docker-gitlab-firstrun' :
    require => File['/opt/gitlab'],
    command => "docker run --name=gitlab -i -t --rm -e \"DB_HOST=${ipaddress_eth0}\" -e \"DB_NAME=gitlabhq_production\" -e \"DB_USER=gitlab\" -e \"DB_PASS=password\" -v /opt/gitlab/data:/home/git/data sameersbn/gitlab:7.0.0 app:rake gitlab:setup force=yes",
    onlyif => "test -z `docker ps -a | grep gitlab`",
    timeout => 0
  }->
  exec { 'docker-normal-run' :
    onlyif => "test -n `docker ps -a | grep gitlab`",
    command => "docker run --name=gitlab -d -e \"DB_HOST=${ipaddress_eth0}\" -e \"DB_NAME=gitlabhq_production\" -e \"DB_USER=gitlab\" -e \"DB_PASS=password\" -e \"GITLAB_PORT=10080\" -e \"GITLAB_SSH_PORT=10022\" -e \"GITLAB_RELATIVE_URL_ROOT=/gitlab\" -p 127.0.0.1:10022:22 -p 127.0.0.1:10080:80 -v /opt/gitlab/data:/home/git/data sameersbn/gitlab:7.0.0",
    timeout => 0
  }
}
