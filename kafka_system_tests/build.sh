#!/bin/bash -e

base_dir=$(dirname $0)

# Detect jdk version
jdk=`javac -version 2>&1 | cut -d ' ' -f 2`
ver=`echo $jdk | cut -d '.' -f 2`
if (( $ver > 6 )); then
    echo "Found jdk version $jdk"
    echo "You should only build with jdk 1.6 or below."
    exit 1
fi

GIT_MODE="git@github.com:"
while [ $# -gt 0 ]; do
  OPTION=$1
  case $OPTION in
    --update)
      UPDATE="yes"
      shift
      ;;
    --aws)
      GIT_MODE="https://github.com/"
      shift
      ;;
    *)
      break
      ;;
  esac
done

# Default JAVA_HOME for EC2
if [ -z "$JAVA_HOME" ]; then
    export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
fi

# Default gradle for local gradle download, e.g. on EC2
if [ ! `which gradle` ]; then
    export PATH=$base_dir/`find . | grep gradle-.*/bin$`:$PATH
fi

KAFKA_VERSION=0.8.2.0

if [ ! -d $base_dir/kafka ]; then
    echo "Cloning Kafka"
    git clone http://git-wip-us.apache.org/repos/asf/kafka.git $base_dir/kafka
fi

pushd $base_dir/kafka

if [ "x$UPDATE" == "xyes" ]; then
    echo "Updating Kafka"
    git fetch origin
fi

git checkout tags/$KAFKA_VERSION

# FIXME we should be installing the version of Kafka we built into the local
# Maven repository and making sure we specify the right Kafka version when
# building our own projects. Currently ours link to whatever version of Kafka
# they default to, which should work ok for now.
echo "Building Kafka"
KAFKA_BUILD_OPTS=""
if [ "x$SCALA_VERSION" != "x" ]; then
    KAFKA_BUILD_OPTS="$KAFKA_BUILD_OPTS -PscalaVersion=$SCALA_VERSION"
fi
if [ ! -e gradle/wrapper/ ]; then
    gradle
fi
./gradlew $KAFKA_BUILD_OPTS jar
popd


