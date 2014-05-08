#
# Cookbook Name:: avahi
# Recipe:: default
#
# Author::  Ben Clark (<ben@benclark.com>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when 'rhel', 'fedora'
  packages = %w{ avahi nss-mdns }
when 'debian'
  packages = %w{ avahi-daemon }
end

packages.each do |pkg|
  package pkg do
    action :install
  end
end

# Config the avahi-daemon
template '/etc/avahi/avahi-daemon.conf' do
  source 'avahi-daemon.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, "service[avahi-daemon]", :delayed
end

# Start the avahi-daemon
service 'avahi-daemon' do
  action :start
end

# Install avahi-aliases
# @todo
