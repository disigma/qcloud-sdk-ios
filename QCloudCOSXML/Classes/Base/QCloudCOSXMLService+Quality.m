//
//  QCloudCOSXML+Quality.m
//  QCloudCOSXML
//
//  Created by erichmzhang(张恒铭) on 2018/8/23.
//
#define kQAUploadStrategy @(2)
#define kQAccount @"Iqcloud103800"
#import "QCloudCOSXMLService+Quality.h"
#import <objc/runtime.h>


#import <QCloudCore/QCloudCore.h>
#import <QCloudCore/QCloudLogger.h>
#import "QCloudCOSXMLVersion.h"
@implementation QCloudCOSXMLService (Quality)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self changeImplementation];
    });
    
}

+ (void) changeImplementation {
    Class class = object_getClass((id)self);
    Method originMethod = class_getClassMethod(class, @selector(registerDefaultCOSXMLWithConfiguration:));
    Method replacedMethod = class_getClassMethod(class,  @selector(Quality_registerDefaultCOSXMLWithConfiguration:));
    method_exchangeImplementations(originMethod, replacedMethod);
    
}

+ (QCloudCOSXMLService*) Quality_registerDefaultCOSXMLWithConfiguration:(QCloudServiceConfiguration*)configuration {
    id result = [self Quality_registerDefaultCOSXMLWithConfiguration:configuration];
    
    [self initMTA];
    return result;
}


+ (void) initMTA {
  
    Class cls = NSClassFromString(@"TACMTAConfig");
    if (cls) {
        QCloudLogDebug(@"Quality assurence service start");
        Class config = [cls performSelector:NSSelectorFromString(@"getInstance")];
        [config performSelector:NSSelectorFromString(@"setReportStrategy:") withObject:kQAUploadStrategy];
        [config performSelector:NSSelectorFromString(@"setCustomerAppVersion:") withObject:QCloudCOSXMLModuleVersion];
        Class tacCls = NSClassFromString(@"TACMTA");
        if (tacCls) {
            [tacCls performSelector:NSSelectorFromString(@"startWithAppkey:") withObject:kQAccount];
        }
       
       
     
    }else{
        QCloudLogDebug(@"please pod MTA");
    }
}
@end
