# System Configuration
srcdir = .

prefix ?= /usr/local
exec_prefix ?= $(prefix)

scriptbindir ?= $(prefix)/bin
datadir ?= $(scriptbindir)
datarootdir ?= $(prefix)/share

bindir ?= $(exec_prefix)/bin
libdir ?= $(exec_prefix)/lib
sbindir ?= $(exec_prefix)/sbin

sysconfdir ?= $(shell cygpath -u "$(ALLUSERSPROFILE)")
docdir ?= $(datarootdir)/doc/$(PROJ)
infodir ?= $(datarootdir)/info
mandir ?= $(datarootdir)/man
localstatedir ?= $(prefix)/var

CHECK_SCRIPT_SH = /bin/sh -n

INSTALL = /usr/bin/install -p
INSTALL_PROGRAM = $(INSTALL)
INSTALL_SCRIPT = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_DIR = /usr/bin/install -d -m 755


# Inference Rules

# Macro Defines
PROJ = system_backup_win
VER = 1.0.1
TAG = v$(VER)

TAR_SORT_KEY ?= 6,6

SUBDIRS-TEST-SCRIPTS-SH = \

SUBDIRS-TEST = \
				$(SUBDIRS-TEST-SCRIPTS-SH) \

SUBDIRS = \
				$(SUBDIRS-TEST) \

PROGRAMS = \

SCRIPTS-SH = \
				log_check_system_backup_dev_check_win.sh \
				log_check_system_backup_win.sh \

SCRIPTS-OTHER = \
				system_backup.bat \
				system_backup_dev_check.bat \
				system_backup_dev_check_log_check.bat \
				system_backup_dev_mount.bat \
				system_backup_dev_umount.bat \
				system_backup_echo_log.bat \
				system_backup_log_check.bat \
				system_backup_log_del.bat \

SCRIPTS = \
				$(SCRIPTS-SH) \
				$(SCRIPTS-OTHER) \

DATA = \

DIRS = \
				$(sysconfdir)/system_backup/ \

DOC = \
				LICENSE \
				README.md \
				hdd_change_win.txt \
				hdd_setup_win.txt \
				examples/README.md \
				examples/backup.bat \
				examples/env.local.bat \
				examples/get_file_list.bat \
				examples/src_list.txt \
				examples/svc_start.bat \
				examples/svc_stop.bat \

# Target List
test-recursive \
:
	@target=`echo $@ | sed s/-recursive//`; \
	list='$(SUBDIRS-TEST)'; \
	for subdir in $$list; do \
		echo "Making $$target in $$subdir"; \
		echo " (cd $$subdir && $(MAKE) $$target)"; \
		(cd $$subdir && $(MAKE) $$target); \
	done

all: \
				$(PROGRAMS) \
				$(SCRIPTS) \
				$(DATA) \
				$(DIRS) \

# Check
check: check-SCRIPTS-SH

check-SCRIPTS-SH:
	@list='$(SCRIPTS-SH)'; \
	for i in $$list; do \
		echo " $(CHECK_SCRIPT_SH) $$i"; \
		$(CHECK_SCRIPT_SH) $$i; \
	done

# Test
test:
	$(MAKE) test-recursive

# Install
install: install-SCRIPTS install-DATA install-DOC install-DIRS

install-SCRIPTS:
	@list='$(SCRIPTS)'; \
	for i in $$list; do \
		dir="`dirname \"$(DESTDIR)$(scriptbindir)/$$i\"`"; \
		if [ ! -d "$$dir/" ]; then \
			echo " mkdir -p $$dir/"; \
			mkdir -p $$dir/; \
		fi;\
		echo " $(INSTALL_SCRIPT) $$i $(DESTDIR)$(scriptbindir)/$$i"; \
		$(INSTALL_SCRIPT) $$i $(DESTDIR)$(scriptbindir)/$$i; \
	done

install-DATA:
	@list='$(DATA)'; \
	for i in $$list; do \
		dir="`dirname \"$(DESTDIR)$(datadir)/$$i\"`"; \
		if [ ! -d "$$dir/" ]; then \
			echo " mkdir -p $$dir/"; \
			mkdir -p $$dir/; \
		fi;\
		echo " $(INSTALL_DATA) $$i $(DESTDIR)$(datadir)/$$i"; \
		$(INSTALL_DATA) $$i $(DESTDIR)$(datadir)/$$i; \
	done

install-DOC:
	@list='$(DOC)'; \
	for i in $$list; do \
		dir="`dirname \"$(DESTDIR)$(docdir)/$$i\"`"; \
		if [ ! -d "$$dir/" ]; then \
			echo " mkdir -p $$dir/"; \
			mkdir -p $$dir/; \
		fi;\
		echo " $(INSTALL_DATA) $$i $(DESTDIR)$(docdir)/$$i"; \
		$(INSTALL_DATA) $$i $(DESTDIR)$(docdir)/$$i; \
	done

install-DIRS:
	@list='$(DIRS)'; \
	for i in $$list; do \
		echo " $(INSTALL_DIR) $(DESTDIR)$$i"; \
		$(INSTALL_DIR) $(DESTDIR)$$i; \
	done

# Pkg
pkg:
	@$(MAKE) DESTDIR=$(CURDIR)/$(PROJ)-$(VER).$(ENVTYPE) install; \
	tar cvf ./$(PROJ)-$(VER).$(ENVTYPE).tar ./$(PROJ)-$(VER).$(ENVTYPE) > /dev/null; \
	tar tvf ./$(PROJ)-$(VER).$(ENVTYPE).tar 2>&1 | sort -k $(TAR_SORT_KEY) | tee ./$(PROJ)-$(VER).$(ENVTYPE).tar.list.txt; \
	gzip -f ./$(PROJ)-$(VER).$(ENVTYPE).tar; \
	rm -fr ./$(PROJ)-$(VER).$(ENVTYPE)

# Dist
dist:
	@git archive --format=tar --prefix=$(PROJ)-$(VER)/ $(TAG) > ../$(PROJ)-$(VER).tar; \
	tar tvf ../$(PROJ)-$(VER).tar 2>&1 | sort -k $(TAR_SORT_KEY) | tee ../$(PROJ)-$(VER).tar.list.txt; \
	gzip -f ../$(PROJ)-$(VER).tar
