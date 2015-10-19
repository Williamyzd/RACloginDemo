//
//  ViewController.m
//  RACloginDemo
//
//  Created by admin on 15/10/18.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "ViewController.h"
#import  <ReactiveCocoa/ReactiveCocoa.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ViewController

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    if ([self valueIsOk:_userName.text] && [self valueIsOk:_passWord.text]
//        ) {
//        self.loginBtn.enabled = YES;
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *ctr = [[UIViewController alloc] init];
    ctr.view.backgroundColor = [UIColor redColor];
    [self loginWithUserName:self.userName PassWord:self.passWord LoginBtn:self.loginBtn andNext:ctr];
    
}
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
