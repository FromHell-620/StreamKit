/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice+Hardware.h"

@implementation UIDevice (Hardware)

#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}

- (NSString *) platform
{
    return [self getSysInfoByName:"hw.machine"];
}


// Thanks, Tom Harrington (Atomicbird)
- (NSString *) hwmodel
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger) totalMemory
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark file system -- Thanks Joachim Bean!

/*
 extern NSString *NSFileSystemSize;
 extern NSString *NSFileSystemFreeSize;
 extern NSString *NSFileSystemNodes;
 extern NSString *NSFileSystemFreeNodes;
 extern NSString *NSFileSystemNumber;
*/

- (NSNumber *) totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils

- (UIDeviceFamily) deviceFamily
{
    NSString *platform = [self platform];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    if ([platform hasPrefix:@"AppleTV"]) return UIDeviceFamilyAppleTV;
    
    return UIDeviceFamilyUnknown;
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSString *) macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];

    free(buf);
    return outstring;
}

-(UIHardwareModel)hardwareModel {
    static UIHardwareModel _hardwareModel;
    
    if(!_hardwareModel) {
        size_t size;
        char *model;
        
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        model = malloc(size);
        sysctlbyname("hw.machine", model, &size, NULL, 0);
        
        NSString *hwString = [NSString stringWithCString: model encoding: NSUTF8StringEncoding];
        free(model);
        
        _hardwareModel = UIHardwareModelUnknown; // Unknown by default
        
        if([hwString isEqualToString: @"i386"] || [hwString isEqualToString:@"x86_64"])
            _hardwareModel = UIHardwareModelSimulator;
        
        if([hwString isEqualToString: @"iPhone1,1"])
            _hardwareModel = UIHardwareModeliPhone1G;
        
        if([hwString isEqualToString: @"iPhone1,2"])
            _hardwareModel = UIHardwareModeliPhone3G;
        
        if([hwString isEqualToString: @"iPhone2,1"])
            _hardwareModel = UIHardwareModeliPhone3GS;
        
        if([hwString isEqualToString: @"iPhone3,1"])
            _hardwareModel = UIHardwareModeliPhone4;
        
        if([hwString isEqualToString: @"iPhone3,2"])
            _hardwareModel = UIHardwareModeliPhone4Verizon;
        
        if([hwString isEqualToString: @"iPhone4,1"])
            _hardwareModel = UIHardwareModeliPhone4S;
        
        if([hwString isEqualToString: @"iPod1,1"])
            _hardwareModel = UIHardwareModeliPodTouch1G;
        
        if([hwString isEqualToString: @"iPod2,1"])
            _hardwareModel = UIHardwareModeliPodTouch2G;
        
        if([hwString isEqualToString: @"iPod3,1"])
            _hardwareModel = UIHardwareModeliPodTouch3G;
        
        if([hwString isEqualToString: @"iPod4,1"])
            _hardwareModel = UIHardwareModeliPodTouch4G;
        
        if([hwString isEqualToString: @"iPad1,1"])
            _hardwareModel = UIHardwareModeliPad;
        
        if([hwString isEqualToString: @"iPad2,1"])
            _hardwareModel = UIHardwareModeliPad2Wifi;
        
        if([hwString isEqualToString: @"iPad2,2"])
            _hardwareModel = UIHardwareModeliPad2GSM;
        
        if([hwString isEqualToString: @"iPad2,3"])
            _hardwareModel = UIHardwareModeliPad2CDMA;
        
        if([hwString isEqualToString: @"iPad2,4"])
            _hardwareModel = UIHardwareModeliPad2Wifi;
        
        if([hwString isEqualToString: @"iPad3,1"])
            _hardwareModel = UIHardwareModeliPad3Wifi;
        
        if([hwString isEqualToString: @"iPad3,2"])
            _hardwareModel = UIHardwareModeliPad3GSM;
        
        if([hwString isEqualToString: @"iPad3,3"])
            _hardwareModel = UIHardwareModeliPad3CDMA;
        
        if([hwString isEqualToString: @"iPhone5,1"])
            _hardwareModel = UIHardwareModeliPhone5;
        
        if([hwString isEqualToString: @"iPhone5,2"])
            _hardwareModel = UIHardwareModeliPhone5Global;
        
        if([hwString isEqualToString: @"iPhone5,3"])
            _hardwareModel = UIHardwareModeliPhone5c;
        
        if([hwString isEqualToString: @"iPhone5,4"])
            _hardwareModel = UIHardwareModeliPhone5cGlobal;
        
        if([hwString isEqualToString: @"iPhone6,1"])
            _hardwareModel = UIHardwareModeliPhone5s;
        
        if([hwString isEqualToString: @"iPhone6,2"])
            _hardwareModel = UIHardwareModeliPhone5sGlobal;
        
        if([hwString isEqualToString: @"iPod5,1"])
            _hardwareModel = UIHardwareModeliPodTouch5G;
        
        if([hwString isEqualToString: @"iPad2,5"])
            _hardwareModel = UIHardwareModeliPadMiniWifi;
        
        if([hwString isEqualToString: @"iPad2,6"])
            _hardwareModel = UIHardwareModeliPadMiniGSM;
        
        if([hwString isEqualToString: @"iPad2,7"])
            _hardwareModel = UIHardwareModeliPadMiniCDMA;
        
        if([hwString isEqualToString: @"iPad3,4"])
            _hardwareModel = UIHardwareModeliPad4Wifi;
        
        if([hwString isEqualToString: @"iPad3,5"])
            _hardwareModel = UIHardwareModeliPad4GSM;
        
        if([hwString isEqualToString: @"iPad3,6"])
            _hardwareModel = UIHardwareModeliPad4CDMA;
        
        if([hwString isEqualToString: @"iPad5,2"])
            _hardwareModel = UIHardwareModeliPad4CDMA;
        
        if([hwString isEqualToString: @"iPhone7,1"])
            _hardwareModel = UIHardwareModeliPhone6Plus;
        
        if([hwString isEqualToString: @"iPhone7,2"])
            _hardwareModel = UIHardwareModeliPhone6;
        
        if([hwString isEqualToString: @"iPhone8,1"])
            _hardwareModel = UIHardwareModeliPhone6s;
        
        if([hwString isEqualToString: @"iPhone8,2"])
            _hardwareModel = UIHardwareModeliPhone6sPlus;
        
        if([hwString isEqualToString: @"iPad4,4"])
            _hardwareModel = UIHardwareModeliPadMini2Wifi;
        
        if([hwString isEqualToString: @"iPad4,5"])
            _hardwareModel = UIHardwareModeliPadMini2Cellular;
        
        if([hwString isEqualToString: @"iPad4,6"])
            _hardwareModel = UIHardwareModeliPadMini2CellularChina;
        
        if([hwString isEqualToString: @"iPad4,7"])
            _hardwareModel = UIHardwareModeliPadMini3Wifi;
        
        if([hwString isEqualToString: @"iPad4,8"])
            _hardwareModel = UIHardwareModeliPadMini3Cellular;
        
        if([hwString isEqualToString: @"iPad4,9"])
            _hardwareModel = UIHardwareModeliPadMini3CellularChina;
        
        if([hwString isEqualToString: @"iPad5,1"])
            _hardwareModel = UIHardwareModeliPadMini4Wifi;
        
        if([hwString isEqualToString: @"iPad5,2"])
            _hardwareModel = UIHardwareModeliPadMini4Cellular;
        
        if([hwString isEqualToString: @"iPad4,1"])
            _hardwareModel = UIHardwareModeliPadAirWifi;
        
        if([hwString isEqualToString: @"iPad4,2"])
            _hardwareModel = UIHardwareModeliPadAirCellular;
        
        if([hwString isEqualToString: @"iPad4,3"])
            _hardwareModel = UIHardwareModeliPadAirCellularChina;
        
        if([hwString isEqualToString: @"iiPad5,3"])
            _hardwareModel = UIHardwareModeliPadAir2Wifi;
        
        if([hwString isEqualToString: @"iPad5,4"])
            _hardwareModel = UIHardwareModeliPadAir2Cellular;
        
        if([hwString isEqualToString: @"iPod7,1"])
            _hardwareModel = UIHardwareModeliPodTouch6G;
    }
    
    return _hardwareModel;
}

-(NSString *)hwMachineName
{
    static NSString * name = nil;
    if (!name) {
        size_t size;
        char *model;
        
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        model = malloc(size);
        sysctlbyname("hw.machine", model, &size, NULL, 0);
        
        name = [NSString stringWithFormat:@"%s",model];
        
        free(model);
    }
    return name;
}

- (NSString *)idfv
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}


@end