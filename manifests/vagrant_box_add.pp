
  define autolab::vagrant_box_add {
    exec { "vagrant box add $name":
      provider => powershell,
      timeout  => 0,
      path     => $autolab::vagrant_bin_dir,
      cwd      => $autolab::vagrant_lab_dir,
      require  => [ Package['vagrant'], File[$autolab::vagrant_lab_dir] ],
      unless   => "if ($(vagrant box list) -like \"*$name*\") {exit 0} else {exit 1}",
    }
  }
