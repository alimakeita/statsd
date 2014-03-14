class statsd ($graphite_host, $graphite_port = 2003, $port = 8125, $debug = true, {

## the statsd package 

	package {'statsd':
		ensure => present
	}	

	file {'/opt/statsd':
    	ensure => directory,
    	owner => 'root',
    	group => 'root',
    	mode => '0755',
	}
	
#init script for statsd

	file { '/etc/init.d/statsd':
		ensure => file,
		owner => root, 
		mode => '0644',
		group => 'root,
		source => 'puppet:///modules/statsd/statsd-init.sh',
		notify => Service['statsd'],
	}

#configuration files that need to be in the opt/statsd directory
	file { '/opt/statsd/local.js':
		ensure => file,
		source => 'puppet:///modules/statsd/local.js',
		mode  => '0755',
	}

	file {'/opt/statsd/statsdconf.js':
		ensure => file,
		owner => root,
		group => root,
		mode  => '0775'
		content => template('statsd/statsdconf.js.erb')
		notify => Service['statsd'],
	
	}

#ping file for testing purposes, to make sure connection is established between statsd and graphite
 	
 	file {'/opt/statsd/stats_test.py':
 		ensure => file,
 		source => 'puppet:///modules/statsd/stats_test.py'
 		mode => '0755',
 	} 
	
	service {'statsd':
		ensure     => running,
   	 	enable     => true,
    	hasrestart => true,
    	hasstatus  => true,
    	require    => Package['statsd'],
	}

}