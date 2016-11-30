# example42 control-repo and Tiny Puppet

This Puppet contro-repo has various interesting integrations with [Tiny Puppet](http://tiny-puppet.com), even theye are totally optional, we strongly recommend to give tp a try by using and practising about it: it can same you a lot of time.

Usage of Tiny Puppet ([tp](https://github.com/example42/puppet-tp)) and [tinydata](https://github.com/example42/tinydata) modules (they are both present in the ```Puppetfile```) is at different levels:

  - Several sample profiles use tp defines to manage the relevant applications

  - Some (currently experimental) external modules use tp in module, with local data

  - It's possible to easily install any (known) app locally, via a tp shell wrapper

  - It's possible to create easily data for new apps to manage

  - Integration tests are free on multiple apps and os  out of the box with tp::test


### Install anything anywhere with a tiny command

Image a simple command, which expects as input the name of an application or a software and installs it, taking care of the underlying operating system, the eventual repositories that provide packages, how their names are different on different operating systems, if that app needs other apps or packages installed as prerequisites.

A command like ```install <software>``` that works everywhere.

Well, it exists. Here.

To install locally (you might need root privileges ) *any application on any operating system*, managing all the necessary dependencies, just write from the main dir of this control repo:

    bin/tp_install.sh <app_name>

Or if you prefer to run it via Fabric:
 
    fab tp.install:<app_name>

Prequesities for the magic to happen:

  - Puppet 4 is installed locally. To do it from the control repo:

        bin/puppet_install.sh [redhatX|debian|ubuntu] # WIP on automatic OS detection 

  - This control-repo is provisioned locally (that is it has run r10k to fetch tp and tinydata modules from upstream source). You can do it with:

        bin/puppet_setup.sh

  - There's in tinydata all the needed data to install your application on your OS.


Some possible uses:

    # Setup epel (on RHEL systems)
    bin/tp_install.sh epel

    # Install sysdig (automatically manages dependencies from other tp apps)
    # Requires tp version >= 1.2 and tinydata version >= v0.0.14 )
    bin/tp_install.sh sysdig
 
    # Install puppetserver from Puppet official repos
    bin/tp_install.sh puppetserver

    # Install docker from Docker official repos
    bin/tp_install.sh docker-engine

    # Install OpenJDK
    bin/tp_install.sh openjdk-jdk

    # Install apache for the lazy or mindless ones
    bin/tp_install.sh apache

If some of these or other commands don't work for the selected app on your local operating system, then it's probably a matter of missing or wrong tinydata, which can be easily solved.

Current support for most of the applications in tinydata is for Linux. MacOS and Windows support is technically present, but data is missing for most of the applications.


### Create tiny data for a new application

To replicate the structure of the tinydata directory of an existing application and create data for a **new** app:

    fab tp.clone_data:redis

redis, or whatever you specify as data to be cloned, must exist on tinydata. You will be asked the name of the new app for with create data files based on the redis structure.

### Local or remote integration tests (WIP)

Since tp knows everything (well, enough) about the applications it installs, it knows how to check if they are working correctly.

This can be effortlessly and automatically enabled by using ```tp::test``` on the applications want to test (or by setting to true the ```test_enable``` argument when using tp::install).

In this control repo it's tp testing is enabled by default on all tp installed applications with the following entry on ```hieradata/common.yaml```:

    ---
      tp::test_enable: true

The following Fabric task (will) allow to test on a remote server if applications installed by tp are working correctly. Can be used in CI pipelines, for quick tests or monitoring.

    fab tp.remote_test -H <hostname>


