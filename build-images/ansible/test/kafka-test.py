import testinfra

"""
Test OS Linux
"""
def test_os_release(host):
    assert host.file("/etc/lsb-release").contains("Ubuntu 16.04.6 LTS")


"""
Test Install Packages
"""
def test_java_is_installed(host):
    java = host.package("openjdk-8-jdk")
    assert java.is_installed
    assert java.version.startswith("8")

def test_kafka_is_installed(host):
    java = host.package("kafka")
    assert java.is_installed
    assert java.version.startswith("2.11-0.11.0.3")

def test_datadog_is_installed(host):
    datadog = host.package("datadog-agent")
    assert datadog.is_installed
    assert datadog.version.startswith("1:6")


"""
Test Active and Running Services
"""
def test_sshd_running(host):
    ssh = host.service("ssh")
    assert ssh.is_running
    assert ssh.is_enabled

def test_kafka_running(host):
    kafka = host.service("kafka")
    assert kafka.is_running
    assert kafka.is_enabled

def test_zookeper_running(host):
    zookeeper = host.service("zookeeper")
    assert zookeeper.is_running
    assert zookeeper.is_enabled

# def test_datadog_running(host):
#     datadog = host.service("datadog-agent")
#     assert datadog.is_running
#     assert datadog.is_enabled


"""
Test Socket Services
"""
def test_sshd_socket(host):
    ssh = host.socket("tcp://0.0.0.0:22")
    assert ssh.is_listening

# def test_kafka_socket(host):
#     kafka = host.socket("tcp://0.0.0.0:9092")
#     assert kafka.is_listening

# def test_kafka_jmx_socket(host):
#     kafkajmx = host.socket("tcp://0.0.0.0:9999")
#     assert kafkajmx.is_listening

# def test_zookeeper_socket(host):
#     zookeeper = host.socket("tcp://0.0.0.0:2181")
#     assert zookeeper.is_listening


"""
Test Configurations
"""
def test_swapoff_file(host):
    swapoff = host.file("/etc/sysctl.d/30-swapoff.conf")
    assert swapoff.md5sum == "7ae13b77ecc8fa2d101b7dc4f06c3c22"

def test_server_properties_file(host):
    svp = host.file("/etc/kafka/server.properties")
    assert svp.exists

def test_zookeeper_properties_file(host):
    zkp = host.file("/etc/zookeeper/zookeeper.properties")
    assert zkp.md5sum == "647eee2abd453a78e03e4e021a883ea8"

def test_zookeeper_default_file(host):
    zkd = host.file("/etc/default/zookeeper")
    assert zkd.md5sum == "27e1ef8d3a375e3c9970ff0455508ce3"

def test_kafka_default_file(host):
    kfd = host.file("/etc/default/kafka")
    assert kfd.md5sum == "662648ea6e5eb7432fb6d40927e609f6"

def test_datadog_file(host):
    df1 = host.file("/etc/datadog-agent/datadog.yaml")
    assert df1.md5sum == "b5301abf722ba15bdbf75d9b4fc571da"

def test_datadog_kafka1_file(host):
    df2 = host.file("/etc/datadog-agent/conf.d/kafka.d/conf.yaml")
    assert df2.md5sum == "e98ee4cb0a83157b68fdb5fbea177cb0"

def test_datadog_kafka2_file(host):
    df3 = host.file("/etc/datadog-agent/conf.d/kafka.d/metrics.yaml")
    assert df3.md5sum == "67650107d7658648d26ba07916b6f8fa"

def test_datadog_kafka3_file(host):
    df4 = host.file("/etc/datadog-agent/conf.d/kafka_consumer.d/conf.yaml")
    assert df4.md5sum == "c40d61b4525a73558b2f71461696af9d"

def test_datadog_zookeeper1_file(host):
    df5 = host.file("/etc/datadog-agent/conf.d/zk.d/conf.yaml")
    assert df5.md5sum == "e8d334bee5aa37046fadf07da07cc3d3"

def test_datadog_docker_file(host):
    df6 = host.file("/etc/datadog-agent/conf.d/docker.d/conf.yaml")
    assert df6.md5sum == "1097cec152e6e145eb67daf2330d5a40"

