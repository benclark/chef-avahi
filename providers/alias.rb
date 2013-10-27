action :add do

  file ::File.join('/etc/avahi/aliases.d',new_resource.name) do
    content new_resource.name
    action :create
    notifies :restart, "service[avahi-publish-aliases]", :delayed
  end

end

action :remove do

  bash "avahi-remove-alias-#{new_resource.name}" do
    code <<-EOH
      /usr/bin/avahi-remove-alias #{new_resource.name}
    EOH
  end

end
