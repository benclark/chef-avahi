#
# Cookbook Name:: avahi
# Recipe:: aliases
#
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

if platform_family?("debian")

  include_recipe "git"

  %w{ python-dbus python-avahi }.each do |pkg|
    package pkg
  end

  # Run the installer
  bash "install-avahi-aliases" do
    cwd "/usr/src/avahi-aliases"
    code <<-EOH
      ./install.sh
    EOH
    action :nothing
  end

  # Clone the avahi-aliases repo
  git "/usr/src/avahi-aliases" do
    repo "https://github.com/ahawthorne/avahi-aliases.git"
    action :checkout
    notifies :run, "bash[install-avahi-aliases]", :immediately
  end

  # Create the service
  service "avahi-publish-aliases" do
    supports :start => true, :restart => true, :reload => true
    action :nothing
  end

  # Add the init script
  cookbook_file "avahi-publish-aliases" do
    path "/etc/init.d/avahi-publish-aliases"
    mode "0755"
    notifies :enable, "service[avahi-publish-aliases]"
    notifies :restart, "service[avahi-publish-aliases]", :immediately
  end

else
  Chef::Log.error("Your platform (#{node[:platform]}) is not supported.")
end
