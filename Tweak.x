// Force prefer ultra-wide camera when available
// Build with Theos. Test on your iOS version — may crash some apps.

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

static AVCaptureDevice *ZBD_UltraWide(void) {
    if (@available(iOS 13.0, *)) {
        AVCaptureDeviceDiscoverySession *session =
            [AVCaptureDeviceDiscoverySession
                discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInUltraWideCamera]
                mediaType:AVMediaTypeVideo
                position:AVCaptureDevicePositionBack];
        return session.devices.firstObject;
    }
    return nil;
}

%hook AVCaptureDeviceInput

+ (instancetype)deviceInputWithDevice:(AVCaptureDevice *)device error:(NSError **)error {
    AVCaptureDevice *uw = ZBD_UltraWide();
    if (uw && device.position == AVCaptureDevicePositionBack) {
        // Nếu app đang xin cam sau thường (1x), thử thay bằng ultra-wide
        NSString *t = device.deviceType;
        if ([t isEqualToString:AVCaptureDeviceTypeBuiltInWideAngleCamera] ||
            [t isEqualToString:AVCaptureDeviceTypeBuiltInDualCamera] ||
            [t isEqualToString:AVCaptureDeviceTypeBuiltInTripleCamera]) {
            device = uw;
        }
    }
    return %orig(device, error);
}

%end

%hook AVCaptureDevice

- (void)setVideoZoomFactor:(CGFloat)factor {
    // Giữ zoom thấp (gần góc rộng); tùy máy có thể cần chỉnh
    if (factor > 1.0) {
        factor = 1.0;
    }
    %orig(factor);
}

%end
