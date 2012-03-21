# Definition: artifactory::instance
#
# This module creates an artifactory tomcat server and configures apache.
#
# Parameters:
# ensure
# artifactory_url
# artifactory_ajp
# artifactory_http
# artifactory_server
#
# Actions:
#
# Requires:
#
# Sample Usage:
# 	artifactory::instance {
#		"repo" :
#			ensure => present,
#			artifactory_ajp => $artifactory_ajp,
#			artifactory_http => $artifactory_http,
#			artifactory_server => $artifactory_server,
#	}
define artifactory::instance($ensure, $artifactory_url = 'repo.analytical-labs.com', $artifactory_ajp, $artifactory_http, $artifactory_server) {

  include tomcat::source
  include apache
  include java
  $tomcat_version = "6.0.18"
  include apache::mod_proxy

  apache::vhost {"${artifactory_url}":
    ensure => present,
  }

  tomcat::instance {"${name}":
    ensure      => $ensure,
    ajp_port    => "${artifactory_ajp}",
    http_port	  => "${artifactory_http}",
    server_port => "${artifactory_server}",
  }

  apache::proxypass {"${name}":
    ensure   => $ensure,
    location => "/",
    vhost    => "${artifactory_url}",
    url      => "ajp://localhost:${artifactory_ajp}/",
  }

  file { "/home/tomcat":
    ensure => directory,
    mode => 700,
    owner => tomcat,
  }

}
