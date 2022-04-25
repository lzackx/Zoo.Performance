//
//  ZooResponseImageModel.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooResponseImageModel.h"
#import "ZooUrlUtil.h"

@implementation ZooResponseImageModel
- (instancetype)initWithResponse: (NSURLResponse *)response data:(NSData *) data {
    
    self = [[ZooResponseImageModel alloc] init];
    self.url = response.URL;
    self.data = data;
    int64_t byte = [ZooUrlUtil getResponseLength:(NSHTTPURLResponse *)response data:data];
    self.size = [NSByteCountFormatter stringFromByteCount: byte countStyle: NSByteCountFormatterCountStyleBinary];
    return self;
}
@end
