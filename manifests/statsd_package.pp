#statsd package installation

class statsd::statsd_package {

        ##install the node package 

        vcsrepo { "/opt/node":
        ensure => present,
        provider => git,
        source  => 'https://github.com/joyent/node.git',
        revision => 'master',
        }

#    file {'/opt/node':
#        source => 'puppet:///modules/statsd/node',
#        recurse => true,
#        ensure => directory,
#    }

  
#       exec {'install_node':
#               command => '/opt/ git clone https://github.com/joyent/node 
#               creates => '/opt/node'
#       }


        exec {'install_node':
                command => './configure && make && make install',
        creates => '/opt/node',
                cwd => "/opt/node",
        path => '/opt/node',
#        require => File['/opt/node'],
        }

        file {'/usr/local/bin/node':
                ensure => present,
        }

## installing npm in the /tmp directory


        exec {'install.sh':
                command => '/usr/bin/wget --no-check-certificate http://npmjs.org/install.sh ; sh install.sh',
                creates => '/tmp/install.sh',
                cwd => '/tmp',
        path => '/usr/bin/wget',
##              subscribe => Package ['install.sh']
        }

     package {'npm':
        ensure => present,
    }

        file {'/usr/bin/npm':
                ensure => present,
        }

        exec {'npm install express':  
                command => '/usr/bin/npm install express',
                cwd => '/usr/bin',
        path => '/usr/bin',
#               require => File['/usr/bin/npm'],
        }
}

