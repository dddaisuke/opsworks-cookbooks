#
# Cookbook Name:: dependencies
# Recipe:: update

case node["opsworks"]["ruby_stack"]
when "ruby"
  include_recipe "ruby"
when "ruby_enterprise"
  include_recipe "ruby_enterprise"
end

include_recipe "opsworks_nodejs" if node["opsworks"]["instance"]["layers"].include?("nodejs-app")

include_recipe 'packages'
include_recipe 'gem_support'

case node[:platform]
when 'centos','redhat','fedora','amazon'
  #if node[:dependencies][:upgrade_rpms] - not implemented in the application jet
  if node[:dependencies][:upgrade_debs]
    execute 'yum -y update' do
      action :run
    end
  end
when 'debian','ubuntu'
  if node[:dependencies][:update_debs]
    execute 'apt-get update' do
      action :run
    end
  end

  if node[:dependencies][:upgrade_debs]
    execute 'apt-get upgrade -y' do
      action :run
    end
  end
end
