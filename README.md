# autolab

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with autolab](#setup)
    * [What autolab affects](#what-autolab-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with autolab](#beginning-with-autolab)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module configures and installs all the things required for a local test environment running on a Windows OS.

## Module Description

Begining with an install of Chocolatey, then Vagrant with any Vagrant Boxes specified & Oracle VirtualBox (VMware Workstation to be added soon). 
This module has been tested on Windows 8.1 with PE 3.8.1).

## Setup

### What autolab affects

Installation of the following components: 
- Chocolatey
- Vagrant
- VirtualBox

### Setup Requirements

Assuming this is a standalone developer workstation and not managed by puppet, a masterless puppet setup is used (Puppet PE 3.8.1) - however the module will work using a puppet master.

Ensure that the following modules are installed:
- puppetlabs-stdlib >= 1.0.0
- puppetlabs-powershell >= 1.0.4
- chocolatey-chocolatey >= 1.0.2
- badgerious-windows_env >= 2.2.1


### Beginning with autolab

#### Testing:
An example init.pp can be found in the examples folder. 
Run puppet apply to test:
```
puppet apply "autolab/examples/init.pp" -v
```

## Usage
```
class { 'autolab': }
```

#### To add more vagrant boxes:
```
class { 'autolab':
  vagrant_boxes => [ 'ubuntu/trusty64', 'puppetlabs/centos-6.6-64-puppet' ],
}
```
(NOTE: Consider the amount of time it takes for each vagrant box download, this will affect the puppet run [exec timeout is disabled to permit large downloads])


#### To specify a vagrant version & lab dir:
```
class { 'autolab':
  vagrant_boxes   => [ 'ubuntu/trusty64', 'puppetlabs/centos-6.6-64-puppet' ],
  vagrant_version => '1.7.4',
  vagrant_lab_dir => "c:\\vagrantlab",
}
```


## Limitations

- Tested on Windows 8.1
- 
## Development

Contributions welcome

## Release Notes/Contributors/Etc **Optional**

## 0.1.0
Initial commit

## 0.1.2
Updated docs

## 0.2.0
Added Oracle Virtualbox

## 0.2.1
Added version