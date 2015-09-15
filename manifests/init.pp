# == Class: autolab
#
# Sets up a virtualbox lab; installs chocolatey, vagrant, git, virtualbox for a quick testing environment 
#
# === Examples
#
# autolab {'mylab':
#   vagrant_lab_dir                => "c:\\vagrant",
#   vagrant_boxes              => [ 'ubuntu/trusty64', ],
#   chocolatey_install_ps1_url => "https://chocolatey.org/install.ps1",
#   chocolatey_path            => "%ALLUSERSPROFILE%\\chocolatey\\bin",
#   temp_dir                   => "c:\\windows\\temp",
# }
#
# === Authors
#
# David Newton <davidnewton@zoojar.com>
#
# === Copyright
#
# Copyright 2015 David Newton.
#
class autolab (
  $chocolatey_install_ps1_url = $autolab::params::chocolatey_install_ps1_url,
  $chocolatey_path            = $autolab::params::chocolatey_path,
  $virtualbox_version         = $autolab::params::virtualbox_version,
  $vagrant_lab_dir            = $autolab::params::vagrant_lab_dir,
  $vagrant_boxes              = $autolab::params::vagrant_boxes,
  $vagrant_bin_dir            = $autolab::params::vagrant_bin_dir,
  $vagrant_version            = $autolab::params::vagrant_version,
  $temp_dir                   = $autolab::params::temp_dir,
  $powershell_exe_path        = $autolab::params::powershell_exe_path,

) inherits autolab::params {
  
  windows_env { "PATH=$chocolatey_path": }
  
  exec { "install-chocolatey":
    require  => Windows_env["PATH=$chocolatey_path"],
    creates  => "C:\\ProgramData\\Chocolatey",
    provider => 'powershell',
    command  => 'iex ((new-object net.webclient).DownloadString(\'https://chocolatey.org/install.ps1\'))',                                                    
  }

  package { 'virtualbox':
    ensure   => $virtualbox_version,
    provider => 'chocolatey',
  }

  package { 'vagrant':
    ensure    => $vagrant_version,
    provider  => 'chocolatey',
  }

  file { $vagrant_lab_dir:
    ensure => directory,
  }

  exec { 'vagrant init':
    provider => powershell,
    path     => $vagrant_bin_dir,
    cwd      => $vagrant_lab_dir,
    creates  => "$vagrant_lab_dir\\Vagrantfile",
    require  => [
      Package['vagrant'],
      File[$vagrant_lab_dir],
    ],
  }
  exec { 'vagrant plugin install vagrant-reload':
    provider => powershell,
    path     => $vagrant_bin_dir,
    cwd      => $vagrant_lab_dir,
    unless   => 'if ($(vagrant plugin list) -like "*vagrant-reload*") {exit 0} else {exit 1}',
    require  => [
      Package['vagrant'],
      File[$vagrant_lab_dir],
    ],
  }
  
  
  autolab::vagrant_box_add { $vagrant_boxes: }

}
