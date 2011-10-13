class jenkins {

include tomcat::source
include apache
include java
$tomcat_version = "6.0.18"
include git::client
include subversion
apache::module {"proxy_ajp":
  ensure  => present,
}

apache::vhost {"ci.analytical-labs.com":
  ensure => present,
}

tomcat::instance {"jenkins":
  ensure      => present,
  ajp_port    => "8009",
}

apache::proxypass {"jenkins":
  ensure   => present,
  location => "/",
  vhost    => "ci.analytical-labs.com",
  url      => "ajp://localhost:8009/",
}

file { "/var/www/ci.analytical-labs.com/htdocs/index.html":
	ensure => present,
	source => "puppet:///modules/jenkins/index.html",
	require => Apache::Vhost["ci.analytical-labs.com"],
}

file { "/home/tomcat":
	ensure => directory,
	mode => 700,
	owner => tomcat,
}
}
