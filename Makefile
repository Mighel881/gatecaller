ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard
FINALPACKAGE = 1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GateCaller

GateCaller_FILES = Tweak.x
GateCaller_CFLAGS = -fobjc-arc
GateCaller_LIBRARIES = activator

include $(THEOS_MAKE_PATH)/tweak.mk
