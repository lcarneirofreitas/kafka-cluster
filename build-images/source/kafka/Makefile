NAME=kafka
VERSION=2.3.0
MINOR=2.12

.PHONY: package
package:
	rm -rf $(NAME)_*
	wget --no-check-certificate https://archive.apache.org/dist/$(NAME)/$(VERSION)/$(NAME)_$(MINOR)-$(VERSION).tgz
	tar -xvzf $(NAME)_$(MINOR)-$(VERSION).tgz
	fpm -s dir -t deb -n $(NAME) -v $(MINOR)-$(VERSION) \
		-C $(NAME)_$(MINOR)-$(VERSION) \
		-d "openjdk-8-jdk" \
		--description "Kafka Project Teravoz" \
		--prefix /opt/kafka \
		--config-files etc/kafka/server.properties \
		--config-files etc/zookeeper/zookeeper.properties \
		--deb-default etc/default/kafka \
		--deb-default etc/default/zookeeper \
		--deb-systemd etc/systemd/system/kafka.service \
		--deb-systemd etc/systemd/system/zookeeper.service \
		--pre-install preinst \
		--post-install postinst \
		bin config libs site-docs LICENSE NOTICE
	cp *.deb ../../ansible/files/kafka/

