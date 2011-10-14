class artifactory {

include tomcat::source
include apache
include java
$tomcat_version = "6.0.18"
include apache::mod_proxy

apache::vhost {"repo.analytical-labs.com":
  ensure => present,
}

tomcat::instance {"repo":
  ensure      => present,
  ajp_port    => "8010",
  http_port	  => "8081",
  server_port => "8006",
}

apache::proxypass {"repo":
  ensure   => present,
  location => "/",
  vhost    => "repo.analytical-labs.com",
  url      => "ajp://localhost:8010/",
}

file { "/home/tomcat":
	ensure => directory,
	mode => 700,
	owner => tomcat,
}
}
