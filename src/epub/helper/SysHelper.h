#import <Foundation/Foundation.h>
#include <sys/socket.h>  
#include <sys/sysctl.h>  
#include <net/if.h>  
#include <net/if_dl.h>  

@interface SysHelper : NSObject

+(NSString *)getMacAddress;

@end
