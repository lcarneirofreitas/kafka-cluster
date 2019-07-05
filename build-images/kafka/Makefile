NAME=kafka
VERSION=2.1.1
MINOR=2.12

.PHONY: package
package:
	rm -rf $(NAME)_*
	wget http://apache.mirror.digitalpacific.com.au/kafka/$(VERSION)/$(NAME)_$(MINOR)-$(VERSION).tgz
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
		--deb-init etc/init.d/kafka \
		--deb-init etc/init.d/zookeeper \
		--pre-install preinst \
		--post-install postinst \
		bin config libs site-docs LICENSE NOTICE

