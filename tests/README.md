System Integration & Performance Testing
========================================

This directory contains Kafka system integration and performance tests. 
[Ducktape](https://github.com/confluentinc/ducktape) is used to run the tests.  

Ducktape is a distributed testing framework which provides test runner, 
result reporter and utilities to pull up and tear down services. It automatically
discovers tests from a directory and generate an HTML report for each run.

To run the tests: 

1. Build a specific branch of Kafka
       
        $ cd kafka
        $ git checkout $BRANCH
        $ gradle
        $ ./gradlew jar
      
2. Setup a testing cluster. You can use Vagrant to create a cluster of local 
   VMs or on EC2. Configure your Vagrant setup by creating the file 
   `Vagrantfile.local` in the directory of your Kafka checkout. At a minimum
   , you *MUST* set the value of num_workers high enough for the test you're 
   trying to run. Note that as the `Vagrantfile` is also used to create a Kafka
   cluster, you need to set num_zookeepers and num_brokers to be 0 in order
   to run the test. 
        
3. Bring up the cluster, making sure you have enough workers. For Vagrant, 
   use `vagrant up`. If you want to run on AWS, use `vagrant up
   --provider=aws --no-parallel`. Once your cluster is up, create a symbolic
   link to point to a 
        
        $ cd kafka
        $ vagrant up
        $ cd tests
        $ ln -s ../.vagrant .vagrant
4. Install ducktape, make sure you have setuptools installed
       
        $ git clone https://github.com/confluentinc/ducktape
        $ cd ducktape
        $ python setup.py install
5. Add Kafka system tests to $PYTHONPATH so that it is discoverable by ducktape

        $ export PYTHONPATH=$PYTHONPATH:<path to kafka system tests>
6. Run the system tests using ducktape
        
        $ cd tests
        $ ducktape system_tests/tests
7. To iterate/run again if you made any changes:

        $ cd kafka
        $ ./gradlew jar
        $ vagrant rsync # Re-syncs build output to cluster