import testinfra
  
def test_os_release(host):
    assert host.file("/etc/os-release").contains("ubuntu")

def test_sshd_inactive(host):
    assert host.service("/usr/sbin/sshd").is_running is False

def test_package_java(host):
    assert host.package('openjdk-8-jdk').is_installed is True

def test_package_nginx(host):
    assert host.package('firefox').is_installed is True


def test_passwd_file(host):
    passwd = host.file("/etc/passwd")
    assert passwd.contains("root")
    assert passwd.user == "root"
    assert passwd.group == "root"
    assert passwd.mode == 0o644


def test_nginx_is_installed(host):
    nginx = host.package("nginx")
    assert nginx.is_installed
    assert nginx.version.startswith("1.16")


def test_nginx_running_and_enabled(host):
    nginx = host.service("nginx")
    assert nginx.is_running
    assert nginx.is_enabled