TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = Zalo

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ForceUltraWide
ForceUltraWide_FILES = Tweak.x
ForceUltraWide_CFLAGS = -fobjc-arc
ForceUltraWide_FRAMEWORKS = AVFoundation UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
