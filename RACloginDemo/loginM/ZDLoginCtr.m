//
//  ZDLoginCtr.m
//  
//
//  Created by admin on 15/10/19.
//
//

#import "ZDLoginCtr.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ZDLoginCtr ()

@end

@implementation ZDLoginCtr
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加控件
}
//一键登录
- (void)loginWithUserName:(UITextField *)userName PassWord:(UITextField *) passWord LoginBtn:(UIButton *)loginBtn andNext:(id) controller{
    RACSignal *loginSingnle = [RACSignal combineLatest:@[[self setTextFieldUI:userName],[self setTextFieldUI:passWord]] reduce:^id(NSNumber *userNameValue,NSNumber *passwordValue){
        return @([userNameValue boolValue] && [passwordValue boolValue]);
    }];
    //动态设置按钮是否可用
    [loginSingnle subscribeNext:^(NSNumber *x) {
        loginBtn.enabled = [x boolValue];
    }];
    
    [[[[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x) {
           loginBtn.enabled =NO;
       }]map:^id(id value) {
           return @([self cheakLoginDateWithName:userName.text Pwd:passWord.text]);
       }]
     subscribeNext:^(NSNumber *x) {
         loginBtn.enabled = YES;
         NSLog(@"%@",x);
         if ([x boolValue]) {
              passWord.text =@"";
             [self.navigationController pushViewController:controller animated:YES];
             
         }
         
     }];
    
    
}
//数据请求

- (BOOL)cheakLoginDateWithName:(NSString *)nameValue Pwd:(NSString *)pwdValue{
    
    BOOL success = [nameValue isEqualToString:@"123456"] && [pwdValue isEqualToString:@"123456"];
    if (!success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"账号或密码错误");
    }
    return success;
}
//设置输入状态
- (RACSignal *)setTextFieldUI:(UITextField *) input{
    // 文本框非空
    RACSignal *inputSingnal =[input.rac_textSignal map:^id(NSString *text) {
        return @([self valueIsOk:text]);
    }];
    //有文字时颜色变化
    RAC(input, backgroundColor) = [inputSingnal map:^id(NSNumber *value) {
        return [value boolValue]? [UIColor orangeColor] : [UIColor clearColor];
    }];
    
    
    return inputSingnal;
}

- (BOOL)valueIsOk:(NSString *)input{
    return input.length>0;
}
@end
