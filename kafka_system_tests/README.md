# kafka_system_tests
Kafka system tests
System Integration & Performance Testing
========================================

This repository contains scripts for running Kafka system integration and 
performance tests. It provides utilities for pulling up and tearing down
services easily, using Vagrant to let you test things on local VMs or run on EC2
nodes. Tests are just Python scripts that run a set of services, possibly
triggering special events (e.g. bouncing a service), collect results (such as
logs or console output) and report results (expected conditions met, performance
results, etc.).

1. Use the `build.sh` script to make sure you have all the projects checked out
   and built against the specified versions.
2. Configure your Vagrant setup by creating the file `Vagrantfile.local`. At a
   minimum, you *MUST* set the value of num_workers high enough for the tests
   you're trying to run.
3. Bring up the cluster with Vagrant for testing, making sure you have enough
   workers, with `vagrant up`. If you want to run on AWS, use `vagrant up
   --provider=aws --no-parallel`.
4. Add Kafka system tests to $PYTHONPATH:

        $ export PYTHONPATH=$PYTHONPATH:<path to kafka system tests>
5. Run the system tests using ducktape
        
        $ ducktape kafka_system_tests/tests
6. To iterate/run again if you already initialized the repositories:

        $ build.sh --update
        $ vagrant rsync # Re-syncs build output to cluster