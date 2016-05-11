# example42 Puppet control-repo

A state of the art, feature rich, Puppet 4 control-repo where you can:

  - Explore the layout of a modern, general purpose, control-repo 
  - Use Puppet 4 optimised modules with updated design patterns
  - Test your code in the Docker and Vagrant environments
  - Fork a clone as starting point for your Puppet infrastructure

Released under the terms of Apache2 licence.

Copyright example42 GmbH (and specific commits authors)

Code: [https://github.com/example42/control-repo](https://github.com/example42/control-repo)

Official website: [http://www.example42.com](http://www.example42.com)

Official Support forum: [Google Groups](https://groups.google.com/forum/#!forum/example42-puppet-modules)


## Installation

### Control-repo setup from GitHub:

    git clone git://github.com/example42/control-repo.git
    cd control-repo
    r10k puppetfile install -v
    
### Single example42 Puppet modules

Use the Forge to install single example42 modules (be aware of the deprecated or old (2.x) ones):

    puppet module search example42

or cherry pick them from [GitHub](https://github.com/example42).

### Old versions installation

You can retrieve the old lists of Example42 modules from other versions with:

    git clone --recursive -b 1.0 git://github.com/example42/control-repo.git
    git clone --recursive -b 2.0 git://github.com/example42/control-repo.git
    git clone --recursive -b 3.0 git://github.com/example42/control-repo.git

Note that earlier versions are based on git modules and have not a control-repo structure.


## Common activities

Many useful and common activities related to Puppet code development, testing and deployment can be fulfilled using Fabric. Many Fabric tasks use shell commands and scripts you can invoke directly, if preferred.

Show available Fabric tasks (note: some will be run locally, some on the hosts specified via -H):

    fab -l 

Run a Fabric task:

    fab <task>[:host=<hostname>][,option=value]

Run puppet agent in noop mode on all the known hosts:

    fab puppet.agent_noop

Run puppet agent in a specific node:

    fab puppet.agent:host=web01.example.test

Show the current version of deployed Pupept code on all  nodes:

    fab puppet.current_config

Build the images for testing this control-repo on Docker using different OS.
Note: image building is based on the data in ```hieradata/role/docker_multios_build.yaml``` 

    fab docker.multios_build

Run Puppet apply of the specified role on the given image (name format: ```downcase($::operatingsystem)-$::operatingsystemmajrelease```):

    fab docker.provision:log,ubuntu-14.04
    fab docker.provision:role=log,image=ubuntu-14.04 # This has the same effect

Run vagrant status on all the available Vagrant environments

    fab vagrant.status

Run vagrant provision on all all the running vm of a Vagrant environment

    fab vagrant.provision:env=puppetinfra


## Dependencies

### Single Modules

All the modules have a ```metadata.json``` file where dependencies are described.

Most of the modules require PuppetLabs' stdlib.
Some modules (the ones, of generation 2.x, which use the ```params_lookup``` function) require Puppi.

### Control repo

The modules used (and some example42 other)  in this control repo are defined in the ```Puppetfile``` and can be installed manually via git, from the Forge or via r10k.

To install r10k:

    gem install r10k

To install Fabric you can use the local package providers or pip:

    pip install fabric

### Vagrant

For a correct setup of the Vagrant environment you need some extra plugins:

    vagrant plugin install vagrant-cachier
    vagrant plugin install vagrant-vbguest
    vagrant plugin install vagrant-hostmanager

### Docker

Docker operations via Fabric or using the command line require Docker to be locally installed.

If you use Mac or Windows you need the newer native client, things won't work when using Docker running inside a Virtualbox VM.

You'll need to run ```docker login``` before trying any operation that involves pushing your images to Docker registry.


## Example42 modules evolution

There are currently 4 generations of example42 modules:

* "OLD" modules (Version 1.x) are no more supported or recommended.
  They are supposed to work also on Puppet versions 0.x
  You can give them a look using the 1.0 branch of this repo.

* "NextGen" modules (Version 2.x) were made before the release of Puppet 3.
  They are compatible with Puppet version 2.6 , 3 and, for most, 4.
  You find them linked as git submodules.

* "StdMod" modules (Version 3.x) were supposed to be the next evolution of Example42 modules.
  They adhere to StdMod naming standards and be compatible with Puppet > 2.7 or 3.x
  This is an half baked generation, which was abandoned for other projects.

* Version 4.x modules. Many modules have been deprecated and not maintained anymore.
  They are expected to be Puppet 4 only compliant.
  The structure of the repo has changed radically, all the git submodules have been removed and a
  control-repo style has been introduced.
  With the release of 4.x this repo has been renamed: from *puppet-modules* to *control-repo*.


## Using and understanding this control-repo

The control-repo you find here is what we consider a starting point for a state of the art general purpose Puppet setup.

It's based on a nodeless classification, driven by 3 top scope variables:

  - ```$::role``` - Defines the nodes' role
  - ```$::env``` - Defines the nodes' operational environment
  - ```$::zone``` - Defines the datacenter or region or segment of an infrastructure (optional)

These variables are used in the Hiera's hierarchy (check ```hiera.yaml```) and should be enough to classify univocally any node in a averagely complex infrastructure. Here they are set as external facts (you'll need to set them when provisioning your nodes, as it's done in the Vagrant environment).

The manifests file, ```manifests/site.pp``` sets some resource defaults, includes a baseline profile according to the underlying OS and uses hiera to define what profiles have to be included in each role (a more traditional alternative, based on role classes, is possible).

All the Hiera data is in ```hieradata``` , the file ```hiera.yaml``` shows a possible hierarchy design and uses ```hiera-eyaml``` as backend for keys encryption (no key is currently encrypted, because we are not shipping the generated private key (it's in .gitignore).
You will have to regenerate your hiera-eyaml keys (run, from the main repo dir, ```eyaml createkeys```).

In the ```site``` directory there are local "not public" modules. Basically our profiles and some role examples.

In the ```modules``` directory are placed the public modules, as defined in the ```Puppetfile``` and installed via r10k or librarian-puppet.

The ```vagrant``` directory contains different Vagrant environments with the relevant toolset that can be used to test the same control-repo.
The one in ```vagrant/environments/puppetinfra``` is fully customizable by editing the ```config.yaml``` file. 
