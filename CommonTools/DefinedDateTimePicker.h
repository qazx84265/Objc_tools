//
//  DefinedDateTimePicker.h
//  LYCRM
//
//  Created by 123 on 15/6/17.
//  Copyright (c) 2015年 gykj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    datePickerType = 0,
    timePickerType
}pickerType;


@protocol PickerDelegate <NSObject>

- (void)pickerCancel;
- (void)pickerCommit:(NSString *)str type:(pickerType)type;
- (void)pickedString:(NSString *)str type:(pickerType)type;

@end




@interface DefinedDateTimePicker : UIActionSheet

@property (nonatomic,retain) NSMutableArray *timeQuantumArray;
@property (nonatomic,assign) pickerType type;

@property (nonatomic,retain) UIView *titleView;
@property (nonatomic,retain) UILabel *titleLb;
@property (nonatomic,retain) UIButton *cancelBtn;
@property (nonatomic,retain) UIButton *commitBtn;

@property (nonatomic,retain) UIPickerView *pickerView;

@property (nonatomic,assign) NSInteger currentYear;
@property (nonatomic,assign) NSInteger currentMonth;
@property (nonatomic,assign) NSInteger currentDay;
@property (nonatomic,assign) NSInteger week;
@property (nonatomic,assign) NSInteger min_year;

@property (nonatomic,assign) NSInteger year;
@property (nonatomic,assign) NSInteger month;
@property (nonatomic,assign) NSInteger day;
@property (nonatomic,assign) NSInteger daysOfMonthAndYear;


@property (nonatomic,copy) NSString *timeQuantum;


@property (nonatomic,assign) id<PickerDelegate> pickerDlg;

- (id)initWithTitle:(NSString *)title type:(pickerType)type timeArray:(NSMutableArray *)array delegate:(id)delegate;
- (void)reloadPicker;
@end
