#class statsd ($graphite_host, $graphite_port = 2003, $port = 8125, $debug = true, {

class statsd {
## the statsd package 
#download statsd


	vcsrepo {"/opt/statsd":
		ensure => present,
        provider => git,
        source => 'https://github.com/etsy/statsd.git',
        revision => 'master',
    } 


	file {'/opt/statsd':
    	ensure => present,
#    	owner => 'root',
 #   	group => 'root',
 #   	mode => '0755',
 		require => Vcsrepo["/opt/statsd"],
    }
	}
	
#init script and service set-up for statsd

	file { '/etc/init.d/statsd':
		ensure => present,
        source => 'puppet:///modules/statsd/statsd-init.sh',
		mode => '0755',
	}

	service {'statsd':
		ensure => running,
		enable => true,
		require => File ['/etc/init.d/statsd'], 
	}	

#configuration files that need to be in the opt/statsd directory
	
	file { '/opt/statsd/local.js':
		ensure => file,
		source => 'puppet:///modules/statsd/local.js',
		mode  => '0644',
		require =>File['/opt/statsd']
	}

	file {'/opt/statsd/statsdconf.js':
		ensure => file,
		owner => root,
		group => root,
		mode  => '0644'
		content => template('statsd/statsdconf.js.erb')
		require => File['/opt/statsd'],
	
	}

#ping file for testing purposes, to make sure connection is established between statsd and graphite
 	
 	file {'/opt/statsd/stats_test.py':
 		ensure => file,
 		source => 'puppet:///modules/statsd/stats_test.py'
 		mode => '0755',
 	} 
	
}