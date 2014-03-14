#statsd package installation

class statsd-package{

	package {'node': ensure => present}
	package {'npm': ensure => present}

	
	exec {'install_node':
		command => '/opt/ git clone https://github.com/joyent/node 
		creates => '/opt/node'
	}

	file {'/opt/node/':
		ensure => directory	
	}

	exec {'install_node':
		command => '/opt/node ; ./configure && make && make install'
		require => Package ['nodejs'],
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

#	exec {'/tmp/ wget --no-check-certificate http://npmjs.org/install.sh ; sh install.sh':
#		creates => '/tmp/install.sh'
#		subscribe => Package ['install.sh']
#	}

	file {'/usr/bin/npm':
		ensure => present 
	}

	exec {'/usr/bin/npm install express':
		require => Package ['npm']
	}
}

