#the statsd class 

class statsd {

include statsd::statsd_package

## the statsd package 
#download statsd

#	file {'/opt/statsd':
#    	ensure => directory,
#    	owner => 'root',
#    	group => 'root',
#    	mode => '0755',
#	}

    vcsrepo {"/opt/statsd":
		ensure => present,
        provider => git,
        source => 'https://github.com/etsy/statsd.git',
        revision => 'master',
    }


    firewall {'100 add port 8125 so that we can send data to the statsd server from external sources':
           port => [8125],
           proto => udp,
           action => accept,

} 


    file {'/opt/statsd':
#       source => 'puppet:///modules/statsd/statsd',
#       recurse => true,
       ensure => present,
       require => Vcsrepo["/opt/statsd"],
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
        require => File['/etc/init.d/statsd'],
	}	

#configuration files that need to be in the opt/statsd directory
	
	file { '/opt/statsd/local.js':
		ensure => file,
		source => 'puppet:///modules/statsd/local.js',
		mode  => '0644',
		require => File['/opt/statsd'],
	}

	file { '/opt/statsd/statsdconf.js':
		ensure => file,
		mode  => '0644',
		content => template('statsd/statsdconf.js.erb'),
		require => File['/opt/statsd'],
	
	}

#ping file for testing purposes, to make sure connection is established between statsd and graphite
 	
 	file { '/opt/statsd/stats_test.py':
 		ensure => file,
 		source => 'puppet:///modules/statsd/stats_test.py',
 		mode => '0644',
 	} 
}
