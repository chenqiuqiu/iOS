//
//  BloothListController.m
//  bluetooth
//
//  Created by 陈彦彤 on 18/3/15.
//  Copyright © 2018年 朗阳科技. All rights reserved.
//

#import "BloothListController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ViewController.h"

@interface BloothListController ()
<CBCentralManagerDelegate, CBPeripheralDelegate,UITableViewDelegate, UITableViewDataSource>
{
    CBCentralManager *manager;
    CBPeripheral *discoverPeripheral;
    NSMutableArray *perArr;
    NSMutableArray *dataArr;
}
@property (weak, nonatomic) IBOutlet UITableView *bloothList;
@end

@implementation BloothListController

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    dataArr = [NSMutableArray array];
    perArr = [NSMutableArray array];
    
}
#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"%@",central);
    switch (central.state) {
        case CBManagerStatePoweredOn:
            NSLog(@"可用，已打开");
            [manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
            break;
            
        case CBManagerStatePoweredOff:
            NSLog(@"可用，未打开");
            [manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
            break;
        case CBManagerStateUnsupported:
            NSLog(@"SDK不支持");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"程序未授权");
            break;
        case CBManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    if (peripheral.name.length <= 0) {
        return ;
    }
    NSLog(@"Discovered name:%@,identifier:%@,advertisementData:%@,RSSI:%@", peripheral.name, peripheral.identifier,advertisementData,RSSI);
    if(![dataArr containsObject:peripheral.name]){
        [dataArr addObject:peripheral.name];
        [perArr addObject:peripheral];
        [_bloothList reloadData];
    }
    
}

#pragma mark -UITableViewDataSource
static NSString* cellID = @"cellID";
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%@",dataArr);
    return dataArr.count;
};
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* tableViewCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    // 如果取出的表格行为nil
    if (tableViewCell == nil) {
        //创建一个UITableViewCell对象，并绑定到cellID
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    tableViewCell.textLabel.text = dataArr[indexPath.row];
    return tableViewCell;
};


#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //连接设备
    dispatch_queue_t dataQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dataQueue, ^{
        //设定周边设备，指定代理者
        CBPeripheral *peripheral = (CBPeripheral *)perArr[indexPath.row];
        discoverPeripheral = peripheral;
        discoverPeripheral.delegate = self;
        [manager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
    });
    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController *VC = [st instantiateViewControllerWithIdentifier:@"viewController"];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - CBPeripheralDelegate

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"连接设备成功");
    [manager stopScan];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
