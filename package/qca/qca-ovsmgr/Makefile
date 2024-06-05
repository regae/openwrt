include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=qca-ovsmgr
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://git.codelinaro.org/clo/qsdk/oss/lklm/qca-ovsmgr.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=6c1fafc4fbdc28474d2199fa2bef6e10c89d2118
PKG_MIRROR_HASH:=skip
PKG_VERSION:=12.5.r2-$(call version_abbrev,$(PKG_SOURCE_VERSION))

include $(INCLUDE_DIR)/package.mk

ifeq ($(CONFIG_TARGET_ipq),y)
subtarget:=$(SUBTARGET)
else
subtarget:=$(CONFIG_TARGET_BOARD)
endif

define KernelPackage/qca-ovsmgr
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=Network Devices
  TITLE:=Kernel driver for NSS OpenVSwitch manager
  DEPENDS:=+kmod-openvswitch
  FILES:=$(PKG_BUILD_DIR)/qca-ovsmgr.ko
  AUTOLOAD:=$(call AutoLoad,50,qca-ovsmgr)
endef

define KernelPackage/qca-ovsmgr/Description
Kernel module for NSS OpenVSwitch manager
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/qca-ovsmgr
	$(CP) $(PKG_BUILD_DIR)/exports/ovsmgr.h $(1)/usr/include/qca-ovsmgr/
endef

EXTRA_CFLAGS += -I$(LINUX_DIR)/net/openvswitch -I$(PKG_BUILD_DIR)/exports

define Build/Compile
	$(MAKE) -C "$(LINUX_DIR)" $(strip $(MAKE_OPTS)) \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		ARCH="$(LINUX_KARCH)" \
		M="$(PKG_BUILD_DIR)" \
		EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \
		SoC="$(subtarget)" \
		modules
endef

$(eval $(call KernelPackage,qca-ovsmgr))
