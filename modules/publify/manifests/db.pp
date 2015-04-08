class publify::db{
	
	service { "firewalld":
        ensure => stopped,
        enable => false,
    }
	
	package {'mysql-community-repo':
		ensure => present,
		provider => 'rpm',
		install_options => ["--force"],
		source => "http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm",
	}
	
	package { "mysql-community-server": 
		ensure => present,
		require => Package["mysql-community-repo"]
	}

	service { "mysqld":
        ensure => running,
        enable => true,
		require => Package["mysql-community-server"]
    }
	file { "/tmp/createDBandUser.sql":
        content => template('publify/createDBandUser.sql.erb'),
    }
	file { "/etc/my.cnf":
        content => template('publify/my.cnf.erb'),
		require => Package["mysql-community-server"]
    }
	
	exec { "Create Databases":
		command => "mysql -e '\\. /tmp/createDBandUser.sql'>/var/log/publifydb.log",
		user => 'root',
		path   => "/bin",
		creates => "/var/lib/mysql/$dbname"
	}
}