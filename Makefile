# PPP top-level Makefile for Linux.

DESTDIR = $(INSTROOT)
BINDIR = $(DESTDIR)/sbin
INCDIR = $(DESTDIR)/usr/include
MANDIR = $(DESTDIR)/usr/share/man
ETCDIR = $(INSTROOT)/etc/ppp

# uid 0 = root
INSTALL= install

all:
	cd chat; $(MAKE) $(MFLAGS) all
	cd pppd/plugins; $(MAKE) $(MFLAGS) all
	cd pppd; $(MAKE) $(MFLAGS) all
	cd pppstats; $(MAKE) $(MFLAGS) all
	cd pppdump; $(MAKE) $(MFLAGS) all

install: $(BINDIR) $(MANDIR)/man8 install-progs install-devel install-etcppp
	$(INSTALL) -c -m 755 scripts/pon $(BINDIR)/.
	$(INSTALL) -c -m 755 scripts/poff $(BINDIR)/.
	$(INSTALL) -c -m 755 scripts/plog $(BINDIR)/.
	$(INSTALL) -c -m 755 scripts/ppp-off $(BINDIR)/.
	$(INSTALL) -c -m 755 scripts/pallon $(BINDIR)/.
	mkdir -p $(DESTDIR)/etc/init.d
	$(INSTALL) -c -m 755 scripts/vyatta-ppp $(DESTDIR)/etc/init.d
	( \
		cd $(DESTDIR)/usr/sbin; \
		ln -s -f ../../sbin/pppd .; \
		ln -s -f ../../sbin/poff .; \
		ln -s -f ../../sbin/pon .; \
	)

install-progs:
	cd chat; $(MAKE) $(MFLAGS) install
	cd pppd/plugins; $(MAKE) $(MFLAGS) install
	cd pppd; $(MAKE) $(MFLAGS) install
	cd pppstats; $(MAKE) $(MFLAGS) install
	cd pppdump; $(MAKE) $(MFLAGS) install

install-etcppp: $(ETCDIR) $(ETCDIR)/options $(ETCDIR)/pap-secrets \
		$(ETCDIR)/chap-secrets
	cd etc.ppp; find . -depth | cpio -dump $(ETCDIR)/.
	$(INSTALL) -c -m 644 etc.ppp/options $(ETCDIR)/.
	find usr -depth | cpio -dump $(INSTROOT)/.

install-devel:
	cd pppd; $(MAKE) $(MFLAGS) install-devel

$(ETCDIR)/options:
	#$(INSTALL) -c -m 644 etc.ppp/options $@
$(ETCDIR)/pap-secrets:
	#$(INSTALL) -c -m 600 etc.ppp/pap-secrets $@
$(ETCDIR)/chap-secrets:
	#$(INSTALL) -c -m 600 etc.ppp/chap-secrets $@

$(BINDIR):
	$(INSTALL) -d -m 755 $@
$(MANDIR)/man8:
	$(INSTALL) -d -m 755 $@
$(ETCDIR):
	$(INSTALL) -d -m 755 $@

clean:
	rm -f `find . -name '*.[oas]' -print`
	rm -f `find . -name 'core' -print`
	rm -f `find . -name '*~' -print`
	cd chat; $(MAKE) clean
	cd pppd/plugins; $(MAKE) clean
	cd pppd; $(MAKE) clean
	cd pppstats; $(MAKE) clean
	cd pppdump; $(MAKE) clean

dist-clean:	clean
	rm -f Makefile `find . -name Makefile -print`

#kernel:
#	cd linux; ./kinstall.sh

# no tests yet, one day...
installcheck:
	true
