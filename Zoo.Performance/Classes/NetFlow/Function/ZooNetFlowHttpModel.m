//
//  ZooNetFlowHttpModel.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowHttpModel.h"
#import "ZooNetFlowManager.h"
#import "NSURLRequest+Zoo.h"
#import "ZooUrlUtil.h"

@implementation ZooNetFlowHttpModel

+ (void)dealWithResponseData:(NSData *)responseData response:(NSURLResponse*)response request:(NSURLRequest *)request complete:(void (^)(ZooNetFlowHttpModel *model))complete {
    ZooNetFlowHttpModel *httpModel = [[ZooNetFlowHttpModel alloc] init];
    //request
    httpModel.request = request;
    httpModel.requestId = request.requestId;
    httpModel.url = [request.URL absoluteString];
    httpModel.method = request.HTTPMethod;
    //response
    httpModel.mineType = response.MIMEType;
    httpModel.response = response;
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    httpModel.statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    httpModel.responseData = responseData;
    httpModel.responseBody = [ZooUrlUtil convertJsonFromData:responseData];
    httpModel.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSince1970] - request.startTime.doubleValue];
    httpModel.downFlow = [NSString stringWithFormat:@"%lli",[ZooUrlUtil getResponseLength:(NSHTTPURLResponse *)response data:responseData]];
    [[ZooNetFlowManager shareInstance] httpBodyFromRequest:request bodyCallBack:^(NSData *body) {
        httpModel.requestBody = [ZooUrlUtil convertJsonFromData:body];
        NSUInteger length = [ZooUrlUtil getHeadersLengthWithRequest:request] + [body length];
        httpModel.uploadFlow = [NSString stringWithFormat:@"%zi", length];
        complete(httpModel);
    }];
}

@end
