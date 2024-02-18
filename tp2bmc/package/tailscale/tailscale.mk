###########################################################
#
# tailscale
###########################################################

TAILSCALE_VERSION = 61a1644c2ac63e894336c891067944f8e6c3574f
TAILSCALE_VERSION_NUMBER = v1.60.0
TAILSCALE_SITE = $(call github,tailscale,tailscale,$(TAILSCALE_VERSION))
TAILSCALE_LICENSE = BSD-3-Clause
TAILSCALE_LICENSE_FILES = LICENSE


define TAILSCALE_LOOK_AT_ME
    echo "look at me"
endef

TAILSCALE_PRE_DOWNLOAD_HOOKS += TAILSCALE_LOOK_AT_ME
TAILSCALE_PRE_EXTRACT_HOOKS += TAILSCALE_LOOK_AT_ME
#
# TAILSCALE_PATCH = \
#     https://github.com/tailscale/tailscale/commit/61a1644c2ac63e894336c891067944f8e6c3574f.patch


TAILSCALE_GO_ENV = GOPROXY="proxy.golang.org" GOFLAGS="-mod=readonly"

TAILSCALE_GOMOD = tailscale.com

TAILSCALE_BUILD_TARGETS = \
	cmd/tailscaled

TAILSCALE_LDFLAGS = \
	-X tailscale.com/version.Long=$(TAILSCALE_VERSION_NUMBER) \
	-X tailscale.com/version.Short=$(TAILSCALE_VERSION_NUMBER) \
	-X tailscale.com/version.GitCommit=$(TAILSCALE_VERSION) \
	-w \
	-s

TAILSCALE_BUILD_OPTS += \
	-gcflags=all=-l

TAILSCALE_TAGS = \
    ts_omit_aws,ts_omit_bird,ts_omit_tap,ts_omit_kube,ts_include_cli


define TAILSCALE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/tailscaled $(TARGET_DIR)/usr/sbin/
endef

# define TAILSCALE_INSTALL_TARGET_CMDS
# 	$(INSTALL) -D -m 755 $(BR2_EXTERNAL_TP2BMC_PATH)/package/tailscale/tailscaled \
#         $(TARGET_DIR)/usr/bin/tailscaled
#
#     (cd $(TARGET_DIR)/usr/bin; ln -s tailscaled tailscale)
# endef

define TAILSCALE_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 $(BR2_EXTERNAL_TP2BMC_PATH)/package/tailscale/S999tailscale \
		$(TARGET_DIR)/etc/init.d/S999tailscale
endef

$(eval $(golang-package))