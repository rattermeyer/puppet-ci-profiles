# Profile for a node acting as jenkinsmaster
class profiles::jenkinsmaster (
  $lts = true
) {
  class { 'jenkins':
    lts          => $lts,
    install_java => false,
  }
  include jenkins::master
  exec { 'jenkins-prefix' : 
    command => 'sed -i -e \'s/JENKINS_ARGS="\(.*\)"/JENKINS_ARGS="\1 --prefix=$PREFIX"/g\' /etc/default/jenkins',
    onlyif => 'test -z `grep "JENKINS_ARGS" /etc/default/jenkins | grep  "\-\-prefix"`',
    require => Class['jenkins']
  }
  create_resources('jenkins::plugin', hiera_hash('profile::jenkinsmaster::plugins'))
}
