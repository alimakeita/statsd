#statsd package installation

class statsd-package{

	##install the node package 

  package { 'node':
    ensure => present,
    group => 'root',
    provider => 'git',
    source => 'https://github.com/joyent/node',
    mode   => '0644', 
  
  }  

  file {'/opt/node':
  	ensure => directory
  	notify => Package['node'],

  }

  package {'node': ensure => present}
	
#	exec {'install_node':
#		command => '/opt/ git clone https://github.com/joyent/node 
#		creates => '/opt/node'
#	}

#	file {'/opt/node/':
#		ensure => directory	
#	}

	exec {'install_node':
		command => '/opt/node ; ./configure && make && make install'
		creates => "/opt/node"
		require => Package ['node'],
	}

	file {'/usr/local/bin/node':
		ensure => present
	}

## installing npm in the /tmp directory

#	package {'install.sh':
#		name = $install.sh
#		ensure => latest,
#		source => '/tmp/$install.sh'
##		provider => 'wget'
#	}


	package {'npm': ensure => present}

	exec {'/tmp/ wget --no-check-certificate http://npmjs.org/install.sh ; sh install.sh':
		creates => '/tmp/install.sh'
##		subscribe => Package ['install.sh']
	}

	file {'/usr/bin/npm':
		ensure => directory,
		require => Package ['npm'],
	}

	exec {'/usr/bin/npm install express':
		require => File ['npm'],

	}
}
