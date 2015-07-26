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
  $vagrant_lab_dir            = $autolab::params::vagrant_lab_dir,
  $vagrant_boxes              = $autolab::params::vagrant_boxes,
  $vagrant_bin_dir            = $autolab::params::vagrant_bin_dir,
  $chocolatey_install_ps1_url = $autolab::params::chocolatey_install_ps1_url,
  $chocolatey_path            = $autolab::params::chocolatey_path,
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

  package { 'vagrant':
    ensure    => '1.7.4',
    provider  => 'chocolatey',
  }

  file { $vagrant_lab_dir:
    ensure => directory,
  }

  exec { 'vagrant init':
    provider => powershell,
    path     => $vagrant_bin_dir,
    cwd      => $vagrant_lab_dir,
    command  => 'vagrant init',
    creates  => "$vagrant_lab_dir\\Vagrantfile",
    require  => [
      Package['vagrant'],
      File[$vagrant_lab_dir],
    ],
  }

  define vagrant_box_add {
    exec { "vagrant box add $name":
      provider => powershell,
      timeout  => 0,
      path     => $autolab::vagrant_bin_dir,
      cwd      => $autolab::vagrant_lab_dir,
      require  => [ Package['vagrant'], File[$autolab::vagrant_lab_dir] ],
      unless   => "if ($(vagrant box list) -like \"*$name*\") {exit 0} else {exit 1}",
    }
  }

  vagrant_box_add { $vagrant_boxes: }
  
  
  # install git
  # setup ssh to clone puppet repos
  # install virtualbox
  # vagrant up boxes
}
