// This header file contains declarations of functions used for detecting license plates in an image

#ifndef DETECT_PLATES_H
#define DETECT_PLATES_H

#include<opencv2/core/core.hpp>
#include<opencv2/highgui/highgui.hpp>
#include<opencv2/imgproc/imgproc.hpp>

#include "Main.h"
#include "PossiblePlate.h"
#include "PossibleChar.h"
#include "Preprocess.h"
#include "DetectChars.h"

/// Constants used for calculating plate width and height.
const double PLATE_WIDTH_PADDING_FACTOR = 1.3;
const double PLATE_HEIGHT_PADDING_FACTOR = 1.5;

/// Function declarations.
std::vector<PossiblePlate> detectPlatesInScene(cv::Mat &imgOriginalScene);

std::vector<PossibleChar> findPossibleCharsInScene(cv::Mat &imgThresh);

PossiblePlate extractPlate(cv::Mat &imgOriginal, std::vector<PossibleChar> &vectorOfMatchingChars);

#endif