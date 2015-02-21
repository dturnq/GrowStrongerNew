//
//  AddSetViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/7/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "AddSetViewController.h"
#import "Set.h"
#import "HorizontalPickerView/HorizontalPickerView.h"
#import "Stopwatch.h"

@interface AddSetViewController ()

@property (strong, nonatomic) UIButton *selectedPickerButton;

-(void)displayPreviousSet:(int)setNum setArray:(NSArray *)setArray;
@property (nonatomic, strong) Stopwatch *stopwatch;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AddSetViewController

-(void)awakeFromNib
{
    self.stopwatch = [[Stopwatch alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //[HorizontalPickerView class];
    
    // Do any additional setup after loading the view.
    
    
    // Basic setup
    self.horizontalPickerView.style = HPStyle_iOS7;
    self.title = self.completedExercise.exercise.name;
    self.selectedPickerButton = self.weight;
    
    
    // Update the buttons & picker with the last set
    PFQuery *query = [Set query];
    
    //NSLog(@"Part 2: set page query CE: %@", self.completedExercise);
    //NSLog(@"Part 2: set page query E: %@", self.completedExercise.exercise.name);
    
    [query whereKey:@"completedExercise" equalTo:self.completedExercise];
    [query fromLocalDatastore];
    [query addAscendingOrder:@"timeStamp"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //NSLog(@"Objects: %@", objects);
        if (objects.count == 0) {
            [self.weight setTitle:@"25" forState:UIControlStateNormal];
            [self.reps setTitle:@"12" forState:UIControlStateNormal];
            [self.horizontalPickerView selectRow:25 animated:YES];
        } else {
            Set *lastSet = [objects lastObject];
            //NSLog(@"Last Object created at: %@", lastSet.createdAt);
            [self.weight setTitle:[lastSet.weight stringValue] forState:UIControlStateNormal];
            [self.reps setTitle:[lastSet.reps stringValue] forState:UIControlStateNormal];
            [self.horizontalPickerView selectRow:[lastSet.weight intValue] animated:YES];
            
            
            // CREATE THE VIEW AT THE BOTTOM
            [self displayPreviousSet:0 setArray:objects];
            for (int setNum=0; setNum<=objects.count; setNum++) {
                
                
            }
            
            
            
            
        }
    }];
    
    //[self.reps setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    // Create the sets on the bottom
    
    
}

-(void)displayPreviousSet:(int)setNum setArray:(NSArray *)setArray
{
    // Show all the previous sets
    
    int xLab = 240 - setNum * 80; // 240
    int yLab = 380; //285;
    int widthLab = 75;
    int heightLab = 18;
    
    long setCount = [setArray count];
    //NSLog(@"setCount: %ld", setCount);
    
    
    
    
    // Create date label for current workout
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(xLab, yLab, widthLab, heightLab)];
    
#warning - currently, if a user saves a completed exercise that does not contain any sets, and no other sets are saved for that exercise during that workout, a bug will appear where the current date will show instead of that workout date. Two possible solutions: 1, when workout is completed, remove all completed exercises (or workouts) that do not contain any sets. 2 - update this function to pull in the data; and then the calling piece of code can pull the date from the workout. You will still have an empty workout date, hoever. 3- in the calling code, simply check whether there are any sets, and if not, exclude.
    NSDate *date = [NSDate date];
    if ([setArray count]) {
        date = [[setArray firstObject] timeStamp];
    }
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d"];
    }
    //[formatter stringFromDate:(NSDate *)exerciseAtIndex.dateAdded]
    dateLabel.text = [formatter stringFromDate:date];
    //dateLabel.font =[UIFont fontWithName:@"HelveticaNeue" size:17];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:dateLabel];
    
    UILabel *label[setCount];
    NSMutableString *text[setCount];
    
    //NSLog(@"Starting loop through setcount");
    for (int i=0; (i < setCount) & (i < 9); i++) {
        //NSLog(@"Interating through loop: i = %u", i);
        if (i == 0) {yLab = yLab + 2;};
        
        yLab = yLab + 20;
        
        label[i] = [[UILabel alloc] initWithFrame:CGRectMake(xLab, yLab, widthLab, heightLab)];
        //label[i].font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
        label[i].textAlignment = NSTextAlignmentCenter;
        
        if ((i == 8) & (setCount > 9)) {
            NSString *string = [NSString stringWithFormat:@"%ld more", setCount - 8];
            text[i] = [[NSMutableString alloc] initWithString:string];
            label[i].text = text[i];
            //label[i].font = [UIFont fontWithName:@"HelveticaNeue-Thin_Italic" size:17];
        }
        else if ([self.completedExercise.exercise.exerciseType isEqual: @"Weightlifting"])
        {
            text[i] = [[NSMutableString alloc] initWithString:@""];
            
            Set *set = [setArray objectAtIndex:i];
            
            [text[i] appendString:[set.weight stringValue]];
            [text[i] appendString:@" / "];
            [text[i] appendString:[set.reps stringValue]];
            
            label[i].text = text[i];
            text[i] = [[NSMutableString alloc] initWithString:@""];
        }
        else
        {
            Set *set = [setArray objectAtIndex:i];
            label[i].text = [set.reps stringValue];
        }
        
        //NSLog(@"Label text: %@", label[i].text);
        
        [self.view addSubview:label[i]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    // Set the initial color of the reps button text
    //[self.reps setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self selectWeightButton:self];
    
    [self updateStopwatchDisplay];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateStopwatchDisplay)
                                                userInfo:nil
                                                 repeats:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -  HPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(HorizontalPickerView *)pickerView
{
    return 1000;
}

#pragma mark -  HPickerViewDelegate

- (NSString *)pickerView:(HorizontalPickerView *)pickerView titleForRow:(NSInteger)row
{
    return [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInteger:row] numberStyle:NSNumberFormatterDecimalStyle];
}

- (void)pickerView:(HorizontalPickerView *)pickerView didSelectRow:(NSInteger)row
{
    [self.selectedPickerButton setTitle:[NSString stringWithFormat:@"%@", @(row)] forState:UIControlStateNormal];
}



- (IBAction)saveSet:(id)sender
{
    
    
}

- (IBAction)selectWeightButton:(id)sender {
    [self.weight setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.reps setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.selectedPickerButton = self.weight;
    [self.horizontalPickerView selectRow:[self.weight.titleLabel.text intValue] animated:YES];
}

- (IBAction)selectRepsButton:(id)sender {
    [self.reps setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.weight setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.selectedPickerButton = self.reps;
    [self.horizontalPickerView selectRow:[self.reps.titleLabel.text intValue] animated:YES];
}


-(void)updateStopwatchDisplay
{
    // Timer for the workout
    NSDate *now = [NSDate date];
    NSTimeInterval secondsElapsed = [now timeIntervalSinceDate:[self.stopwatch workoutStartTime]];
    int hours = trunc(secondsElapsed/3600);
    int minutes = trunc(secondsElapsed/60 - hours*60);
    int seconds = trunc(secondsElapsed - (minutes * 60) - hours*3600);
    NSString *secondsString = nil;
    if (seconds < 10) {
        secondsString = [NSString stringWithFormat:@"0%i", seconds];
    }
    else
    {
        secondsString = [NSString stringWithFormat:@"%i", seconds];
    }
    
    NSString *minutesString = nil;
    if (minutes < 10) {
        minutesString = [NSString stringWithFormat:@"0%i", minutes];
    }
    else
    {
        minutesString = [NSString stringWithFormat:@"%i", minutes];
    }
    
    
    // Timer for the set (ei rest timer)
    NSTimeInterval secondsElapsedSet = [now timeIntervalSinceDate:[self.stopwatch setStartTime]];
    int hoursSet = trunc(secondsElapsedSet/3600);
    int minutesSet = trunc(secondsElapsedSet/60 - hoursSet*60);
    int secondsSet = trunc(secondsElapsedSet - minutesSet*60 - hoursSet*3600);
    NSString *secondsStringSet = nil;
    if (secondsSet < 10) {
        secondsStringSet = [NSString stringWithFormat:@"0%i", secondsSet];
    }
    else
    {
        secondsStringSet = [NSString stringWithFormat:@"%i", secondsSet];
    }
    
    NSString *minutesStringSet = nil;
    if (minutesSet < 10) {
        minutesStringSet = [NSString stringWithFormat:@"0%i", minutesSet];
    }
    else
    {
        minutesStringSet = [NSString stringWithFormat:@"%i", minutesSet];
    }
    
    // Debugging
    // NSLog(@"%@", [NSString stringWithFormat:@"%i:%@:%@", hours, minutesString, secondsString]);
    // NSLog(@"%@", [NSString stringWithFormat:@"%i:%@:%@", hoursSet, minutesStringSet, secondsStringSet]);
    
    
    if (1)
    {
        self.totalTimeLabel.text = [NSString stringWithFormat:@"%i:%@:%@", hours, minutesString, secondsString];
    }
    else
    {
        self.totalTimeLabel.text = [NSString stringWithFormat:@"%@:%@", minutesString, secondsString];
    }
    
    if (1)
    {
        self.setTimeLabel.text = [NSString stringWithFormat:@"%i:%@:%@", hoursSet, minutesStringSet, secondsStringSet];
    }
    else
    {
        self.setTimeLabel.text = [NSString stringWithFormat:@"%@:%@", minutesStringSet, secondsStringSet];
    }
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"SaveSet"]) {
#warning This could potentially be optimized by moving this code into the unwind method in the destination view controller. Then the view can close immediately.
        // Set up the number formatter FML
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        // PFUser
        PFUser *user = [PFUser currentUser];
        
        // Timestamp
        NSDate *now = [NSDate date];
        
        
        Set *newSet = [Set object];
        newSet.weight = [f numberFromString:self.weight.titleLabel.text];
        newSet.reps = [f numberFromString:self.reps.titleLabel.text];
        newSet.user = user;
        newSet.totalWeight = [[NSNumber alloc] initWithInt:(newSet.weight.intValue * newSet.reps.intValue)];
        newSet.workout = self.completedExercise.workout;
        newSet.completedExercise = self.completedExercise;
        newSet.exercise = self.completedExercise.exercise;
        newSet.timeStamp = now;
        newSet.active = @"Active";
        [newSet pinInBackground];
        
        Stopwatch *stopwatch = [[Stopwatch alloc] init];
        [stopwatch setSetStartTime:now];
        //NSLog(@"Part 3: Saved set CE: %@", newSet.completedExercise);
        //NSLog(@"Part 3: Saved set E: %@", newSet.exercise.name);
    }
    
    
}
@end