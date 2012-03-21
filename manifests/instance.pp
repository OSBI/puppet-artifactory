#
# artifactoryinstance.pp
# 
# Copyright (c) 2011, OSBI Ltd. All rights reserved.
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301  USA
#

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
