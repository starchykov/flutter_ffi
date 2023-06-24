#import <Flutter/Flutter.h>

/// Include necessary libraries.
#include<opencv2/core/core.hpp>
#include<opencv2/highgui/highgui.hpp>
#include<opencv2/imgproc/imgproc.hpp>

/// Include other necessary header files.
#include "DetectPlates.h"
#include "PossiblePlate.h"
#include "DetectChars.h"

@interface NativeOpencvPlugin : NSObject<FlutterPlugin>
@end
