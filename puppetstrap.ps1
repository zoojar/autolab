# Autolab puppet strap
# Downloads and installs dependencies for autolab (vagrant, virtualbox & git); 
# - Puppet 3.8.1 
# - Puppet modules
# 
# Example use: 
# .\puppetstrap.ps1
#
$temp_path = "c:\temp"
$puppet_modules = @(
  #"zoojar/autolab",  
  "puppetlabs/stdlib",
  "puppetlabs/powershell",
  "chocolatey/chocolatey",
  "badgerious/windows_env" 
  )
$puppet_msi = "puppet-3.8.1-x64.msi"
$puppet_url = "https://downloads.puppetlabs.com/windows/$puppet_msi"

# Begin
if ( -not (test-path("C:\Program Files\Puppet Labs\Puppet\bin")) ) {
  write-host "Downloading & installing puppet from [$puppet_url] to [$temp_path\$puppet_msi]"
  wget $puppet_url -OutFile "$temp_path\$puppet_msi" ; sleep 1
  msiexec /qn /norestart /i "$temp_path\$puppet_msi"
}

$puppet_modules | % { write-host "Installing puppet module: $($_)..." ;  puppet module install $_ }

$puppet_modulepath = $(puppet config print modulepath).split(";")[0]

# Build & install the autolab module:
puppet module build ..\zoojar-autolab
sleep 1
puppet module install pkg\zoojar-autolab-0.1.0.tar.gz --force
# Run puppet apply...
puppet apply "$puppet_modulepath/autolab/examples/init.pp" -v