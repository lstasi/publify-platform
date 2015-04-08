class publify::lb{
	package { ["epel-release","haproxy"]: ensure => present }
	
	service { "firewalld":
        ensure => stopped,
        enable => false,
    }
	
	service { "haproxy":
        ensure => running,
        enable => true,
		require => Package["haproxy"]
    }
	file { "/etc/haproxy/haproxy.cfg":
        content => template('publify/haproxy.cfg.erb'),
    }
}