class publify::web{
	package { ["epel-release","ruby-devel","gcc-c++","libxml2-devel"]: ensure => present }
	
	package {'mysql-community-repo':
		ensure => present,
		provider => 'rpm',
		install_options => ["--force"],
		source => "http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm",
	}
	package {'mysql-community-devel':
		ensure   => 'present',
		require=>Package["mysql-community-repo"]
	}
	service { "firewalld":
        ensure => stopped,
        enable => false,
    }
	package {'bundle':
		ensure   => 'present',
		provider => gem
	}
	package {'rake':
		ensure   => '10.1.1',
		provider => gem
	}

	file{$publify_folder:
		ensure=>directory
	}
	exec { "Download Package":
		command => "curl -L http://publify.co/stable.tgz -o /tmp/publify.tar.gz",
		path   => "/bin",
		creates => "/tmp/publify.tar.gz"
	}
	
	exec { "Extract Package":
		command => "tar --strip 1 -zxf  /tmp/publify.tar.gz -C $publify_folder",
		path   => "/bin",
		creates => "$publify_folder/README.md",
		require=>[Exec["Download Package"],File[$publify_folder]]
	}
	file { "$publify_folder/config/database.yml":
        content => template('publify/database.yml.erb'),
		require=>Exec["Extract Package"]
    }
	
	exec { "Bundle Install":
		command => "bundle install >bundle_install.log; if [ $? -eq 0 ]; then touch bundle_install.lck; else exit 1; fi",
		cwd => $publify_folder,
		path   => "/usr/local/bin/:/bin",
		creates => "$publify_folder/bundle_install",
		timeout     => 3600,
		require=>[File["$publify_folder/config/database.yml"],Package["bundle","rake","mysql-community-devel","ruby-devel","gcc-c++","libxml2-devel"]]
	}
	exec { "DB Setup":
		command => "rake db:setup >db_setup.log; if [ $? -eq 0 ]; then touch db_setup.lck; else exit 1; fi",
		cwd => $publify_folder,
		path   => "/usr/local/bin/:/bin",
		creates => "$publify_folder/db_setup.lck",
		require=>Exec["Bundle Install"]
	}
	exec { "DB Migrate":
		command => "rake db:migrate >db_migrate.log; if [ $? -eq 0 ]; then touch db_migrate.lck; else exit 1; fi",
		cwd => $publify_folder,
		path   => "/usr/local/bin/:/bin",
		creates => "$publify_folder/db_migrate.log",
		require=>Exec["DB Setup"]
	}
	exec { "DB Seed":
		command => "rake db:seed >db_seed.log; if [ $? -eq 0 ]; then touch db_seed.lck; else exit 1; fi",
		cwd => $publify_folder,
		path   => "/usr/local/bin/:/bin",
		creates => "$publify_folder/db_seed.lck",
		require=>Exec["DB Migrate"]
	}
	exec { "Compile Assets":
		command => "rake assets:precompile >assets.log; if [ $? -eq 0 ]; then touch assets.lck; else exit 1; fi",
		cwd => $publify_folder,
		path   => "/usr/local/bin/:/bin",
		creates => "$publify_folder/assets.lck",
		require=>Exec["DB Seed"]
	}
	exec { "Run Server":
		command => "rails server &>server.log;touch server.lck;",
		cwd => $publify_folder,
		path   => "/usr/local/bin/:/bin",
		creates => "$publify_folder/server.lck",
		require=>Exec["Compile Assets"]
	}
}



