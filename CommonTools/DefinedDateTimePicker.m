//
//  DefinedDateTimePicker.m
//  LYCRM
//
//  Created by 123 on 15/6/17.
//  Copyright (c) 2015年 gykj. All rights reserved.
//

#import "DefinedDateTimePicker.h"

#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

#define VIEW_HEIGHT 200
#define BUTTON_WIDTH 50
#define BUTTON_HEIGHT 40

#define MONTHS 12
#define MAX_YEAR 2100



@interface DefinedDateTimePicker()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,retain) NSArray *weekArray;
@property (nonatomic,assign) NSInteger weekIx;
@end



@implementation DefinedDateTimePicker

@synthesize timeQuantumArray = _timeQuantumArray;
@synthesize type = _type;
@synthesize titleView = _titleView;
@synthesize titleLb = _titleLb;
@synthesize cancelBtn = _cancelBtn;
@synthesize commitBtn = _commitBtn;
@synthesize pickerView = _pickerView;
@synthesize currentYear = _currentYear;
@synthesize currentDay = _currentDay;
@synthesize currentMonth = _currentMonth;
@synthesize year = _year;
@synthesize month = _month;
@synthesize day = _day;
@synthesize daysOfMonthAndYear = _daysOfMonthAndYear;

@synthesize timeQuantum = _timeQuantum;
@synthesize pickerDlg = _pickerDlg;

@synthesize min_year = _min_year;



- (void)reloadPicker {
    if (_type == timePickerType) {
        [_pickerView reloadAllComponents];
    }
}

- (id)initWithTitle:(NSString *)title type:(pickerType)type timeArray:(NSMutableArray *)array  delegate:(id)delegate {
    _type = type;
    _pickerDlg = delegate;
    
    _timeQuantumArray = [[NSMutableArray alloc]init];
    if (type == timePickerType) {
        _timeQuantumArray = array;
    }
    
    self.weekArray = [NSArray arrayWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日", nil];
    
    self = [super init];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEW_HEIGHT);
    self.backgroundColor = [UIColor darkGrayColor];
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BUTTON_HEIGHT)];
    [_titleView setBackgroundColor:KCOLOR(135, 206, 235, 1.0)];
    [self addSubview:_titleView];
    
    _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT)];
    //[_cancelBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    //[_cancelBtn setBackgroundColor:[UIColor greenColor]];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_cancelBtn];
    
    _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_cancelBtn.frame), 0, SCREEN_WIDTH-BUTTON_WIDTH*2, BUTTON_HEIGHT)];
    [_titleLb setText:title];
    [_titleLb setTextColor:[UIColor whiteColor]];
    [_titleLb setTextAlignment:NSTextAlignmentCenter];
    [_titleView addSubview:_titleLb];
    
    _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake( CGRectGetMaxX(_titleLb.frame),0, BUTTON_WIDTH, BUTTON_HEIGHT)];
    //[_commitBtn setBackgroundColor:[UIColor redColor]];
    [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_commitBtn];

    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), SCREEN_WIDTH, VIEW_HEIGHT-BUTTON_HEIGHT)];
    [_pickerView setBackgroundColor:[UIColor whiteColor]];
    _pickerView.tag = 8888;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    if (_type == datePickerType) {    //日期选择器
        NSDate *today = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger calendarFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit/* | NSWeekdayCalendarUnit*/;
        NSDateComponents *dateCompons = [calendar components:calendarFlags fromDate:today];
        _currentYear = [dateCompons year];
        _min_year = _currentYear;
        _currentMonth = [dateCompons month];
        _currentDay = [dateCompons day] + 1;
        _year = _currentYear;
        _month = _currentMonth;
        _day = _currentDay;
        _daysOfMonthAndYear = [self howManyDayOfMonth:_month andYear:_year];
        //超出最大日期
        if (_currentDay>_daysOfMonthAndYear) {
            _currentDay = 1;
            _currentMonth += 1;
            if (_currentMonth > 12) {
                _currentDay = 1;
                _currentMonth = 1;
                _currentYear += 1;
            }
        }
        self.weekIx = [self weekdayOfDay:_day month:_month year:_year];
        if (_timeQuantumArray.count > 0) {
            _timeQuantum = _timeQuantumArray[0];
        }
        
        [_pickerView selectRow:_currentYear inComponent:0 animated:YES];
        [_pickerView selectRow:_currentMonth-1 inComponent:1 animated:YES];
        [_pickerView selectRow:_currentDay-1 inComponent:2 animated:YES];
        //[_pickerView selectRow:0 inComponent:3 animated:YES];
    } else {       //时间段选择器
        [_pickerView selectRow:0 inComponent:0 animated:YES];
    }
    [self addSubview:_pickerView];
    
    
    return self;
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_type == datePickerType) {
        return 4;
    } else {
        return 1;
    }
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_type == datePickerType) {
        switch (component) {
            case 0:{
                return MAX_YEAR - _min_year + 1;
                break;
            }
            case 1:{
                return MONTHS;
                break;
            }
            case 2:{
                return _daysOfMonthAndYear;
            }
            case 3:{
                return 1;
            }
            default: {
                return 0;
                break;
            }
        }
    } else {
        if (_timeQuantumArray.count == 0) {
            return 1;
        } else {
            return _timeQuantumArray.count;
        }
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_type == datePickerType) {
        switch (component) {
            case 0:{
                return [NSString stringWithFormat:@"%ld",_min_year+row];
                break;
            }
            case 1:{
                if (row+1<10) {
                    return [NSString stringWithFormat:@"0%ld",row+1];
                } else {
                    return [NSString stringWithFormat:@"%ld",row+1];
                }
                break;
            }
            case 2:{
                if (row+1<10) {
                    return [NSString stringWithFormat:@"0%ld",row+1];
                } else {
                    return [NSString stringWithFormat:@"%ld",row+1];
                }
                break;
            }
            case 3:{
                if (_year==_currentYear && _month== _currentMonth && _day==_currentDay-1) {
                    return [NSString stringWithFormat:@"今天(%@)",self.weekArray[self.weekIx]];
                } else {
                    return self.weekArray[self.weekIx];
                }
            }
            default:
                return @"";
                break;
        }
    } else {
        
        if (_timeQuantumArray.count == 0) {
            return @"暂无，换个日期试试";
        } else {
            return _timeQuantumArray[row];
        }
    }
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (_type == datePickerType) {
        switch (component) {
            case 0:{
                _year = _min_year+row;
                if (_year == _currentYear) {
                    if (_month <_currentMonth) {
                        [pickerView selectRow:_currentMonth-1 inComponent:1 animated:YES];
                        _month = _currentMonth;
                    }
                    if (_year == _currentYear && _month == _currentMonth) {
                        if (_day < _currentDay) {
                            [pickerView selectRow:_currentDay-1 inComponent:2 animated:YES];
                            _day = _currentDay;
                        }
                    }
                }
                break;
            }
            case 1:{
                _month = row+1;
                if (_year == _currentYear) {
                    if (_month <_currentMonth) {
                        [pickerView selectRow:_currentMonth-1 inComponent:1 animated:YES];
                        _month = _currentMonth;
                    }
                }
                _daysOfMonthAndYear = [self howManyDayOfMonth:_month andYear:_year];
                [pickerView reloadComponent:2];
                break;
            }
            case 2:{
                _day = row+1;
                if (_year == _currentYear && _month == _currentMonth) {
                    if (_day < _currentDay) {
                        [pickerView selectRow:_currentDay-1 inComponent:2 animated:YES];
                        _day = _currentDay;
                    }
                }
                break;
            }
            default:
                
                break;
        }
        
        self.weekIx = [self weekdayOfDay:_day month:_month year:_year];
        [pickerView reloadComponent:3];
        
        NSString *dateStr = [self stringFromYear:_year month:_month day:_day];
        NSLog(@"%@",dateStr);
        
        [self.pickerDlg pickedString:dateStr type:datePickerType];
    } else {
        if (_timeQuantumArray.count > 0) {
            NSLog(@"%@",_timeQuantumArray[row]);
            _timeQuantum = _timeQuantumArray[row];
            [self.pickerDlg pickedString:_timeQuantum type:timePickerType];
        }
    }    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        //pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
    }
    
    
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    if (_type == datePickerType && component == 3) {
        if (_year==_currentYear && _month== _currentMonth && _day==_currentDay-1) {
            [pickerLabel setTextColor:[UIColor redColor]];
        }
    }
    return pickerLabel;
}



#pragma mark ---touches

- (IBAction)cancel:(id)sender {
    /*
     CATransition *animation = [CATransition  animation];
     animation.delegate = self;
     animation.duration = 0.5;
     animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     animation.type = kCATransitionPush;
     animation.subtype = kCATransitionFromBottom;
     [self setAlpha:0.0f];
     [self.layer addAnimation:animation forKey:@"timeQuantumPicker"];
     //[self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
     */
    [self.pickerDlg pickerCancel];
}


- (IBAction)commit:(id)sender {
    /*
     CATransition *animation = [CATransition  animation];
     animation.delegate = self;
     animation.duration = 0.5;
     animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
     animation.type = kCATransitionPush;
     animation.subtype = kCATransitionFromBottom;
     [self setAlpha:0.0f];
     [self.layer addAnimation:animation forKey:@"timeQuantumPicker"];
     //[self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
     */
    //NSString *timeStr = [NSString stringWithFormat:@"%@:%@ - %@:%@",self.startHour,self.startMin,self.endHour,self.endMin];
    
    if (_type == datePickerType) {
        [self.pickerDlg pickerCommit:[self stringFromYear:_year month:_month day:_day] type:_type];
    } else {
        [self.pickerDlg pickerCommit:_timeQuantum type:_type];
    }
}


- (NSString *)stringFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSString *dateStr,*monthStr,*dayStr;
    if (month<10) {
        monthStr = [NSString stringWithFormat:@"0%ld",month];
    } else {
        monthStr = [NSString stringWithFormat:@"%ld",month];
    }
    
    if (day<10) {
        dayStr = [NSString stringWithFormat:@"0%ld",day];
    } else {
        dayStr = [NSString stringWithFormat:@"%ld",day];
    }
    dateStr = [NSString stringWithFormat:@"%ld-%@-%@",year,monthStr,dayStr];
    
    return dateStr;
}


- (NSInteger)howManyDayOfMonth:(NSInteger)month andYear:(NSInteger)year {
    if((month == 1)||(month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12)){
        return 31;
    }
    
    if((month == 4)||(month == 6)||(month == 9)||(month == 11)){
        return 30;
    }
    
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    
    if(year%400 == 0)
        return 29;
    
    if(year%100 == 0)
        return 28;
    
    return 29;
}


- (NSInteger)weekdayOfDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year {
    NSInteger weekIndex = 0;
    weekIndex = (day + 2*month + 3*(month+1)/5 + year + year/4 - year/100 + year/400) % 7;
    
    return weekIndex;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
