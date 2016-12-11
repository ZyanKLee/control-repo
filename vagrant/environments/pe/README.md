# Vagrant environment based on Puppet Enterprise

In this Vagrant environment machines are provisioned with Puppet Enterprise, thanks to the wonderful [pe_build](https://github.com/oscar-stack/vagrant-pe_build) plugin.

By default you have at disposal the ```puppet``` machine, who has a PE allinone installation, and other VMs for other roles, which use puppet agent on the puppet VM (which compiles catalogs based on code and data on this control-repo).

Edit ```config.yaml``` in this directory to customise the VMs to test, the Puppet Enterprise version to use and how you want your Vagrant environment to be.

To work in this Vagrant environment:

    # You need the pe_build plugin (the hostmanager plugin may be also useful)
    vagrant plugin install vagrant-pe_build

    cd <your-control-repo-dir>
    cd vagrant/environment/pe

    # Show available Vagrant machines
    vagrant status

    # Customise them, eventually updating the PE version to use
    vi config.yaml

    # Start the puppet. It will download PE tarball, install it and run puppet agent 
    vagrant up puppet
    vagrant reload puppet   # In case of errors. See Note 1
    vagrant provison puppet # See Note 1

    # Then start the other VM you want to test.
    # They will run puppet agent pointing to the puppet vm
    vagrant up [vm]               # See Note 2


Note 1: The first time a new PE tarball is downloaded from the net you may have an error as what follows, when provisioning the puppet:

    bash: line 2: /vagrant/.pe_build/puppet-enterprise-2016.2.1-el-7-x86_64/puppet-enterprise-installer: No such file or directory

It looks like the newly downloaded PE tarball, placed in the ```.pe_build``` directory of this Vagrant environment, is not immediately available on the VM under its ```/vagrant``` directory.

If the PE installation files are already in place when you vagrant up the puppet, you won't have this error, so the quick solution is (the very first time you use a new PE version):

    vagrant up puppet # It fails if ```.pe_build``` doesn't contain the installation files for your PE version
    vagrant reload puppet # Machines reloads and this times mounts ```/vagrant``` with all the expected files
    vagrant provision puppet # Do the real provisioning: it should install PE and run puppet agent with no errors


Note 2: If you want to start all the default VMs of this environment you will need a *lot* of memory: at least 12 Gb of RAM. Edit ```config.yaml``` to tune the memory to allocate to the VM.


### Usage

To access the PE console from your host browse to **https://127.0.0.1:1443**

Login: **admin**
Password: **puppetlabs**

To access the GitLab installation, browse to **http://127.0.0.1:1080**, insert your admin password, then register a new user.

