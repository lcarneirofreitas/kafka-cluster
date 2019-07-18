## Directory structure:

.
├── ansible
│   ├── files
│   │   ├── datadog
│   │   │   └── etc
│   │   │       ├── apt
│   │   │       │   └── sources.list.d
│   │   │       │       └── datadog.list
│   │   │       └── datadog-agent
│   │   │           ├── conf.d
│   │   │           │   ├── docker.d
│   │   │           │   │   └── conf.yaml
│   │   │           │   ├── kafka_consumer.d
│   │   │           │   │   └── conf.yaml
│   │   │           │   ├── kafka.d
│   │   │           │   │   ├── conf.yaml
│   │   │           │   │   └── metrics.yaml
│   │   │           │   └── zk.d
│   │   │           │       └── conf.yaml
│   │   │           └── datadog.yaml
│   │   ├── docker
│   │   │   └── docker-compose.yml
│   │   └── kafka
│   │       ├── data
│   │       │   └── zookeeper
│   │       │       └── myid
│   │       ├── etc
│   │       │   ├── kafka
│   │       │   │   └── server.properties
│   │       │   └── zookeeper
│   │       │       └── zookeeper.properties
│   │       └── kafka_2.10-0.10.2.2_amd64.deb
│   ├── kafka.yml
│   └── tasks
│       ├── datadog-agent.yml
│       ├── init-ubuntu.yml
│       └── kafka-node.yml
├── build_golden_ami.sh
└── source
    └── kafka
        ├── binary
        │   ├── Packages.gz
        │   └── Sources.gz
        ├── etc
        │   ├── default
        │   │   ├── kafka
        │   │   └── zookeeper
        │   ├── init.d
        │   │   ├── kafka
        │   │   └── zookeeper
        │   ├── kafka
        │   │   └── server.properties
        │   └── zookeeper
        │       └── zookeeper.properties
        ├── Makefile
        ├── postinst
        └── preinst

