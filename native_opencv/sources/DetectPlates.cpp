// DetectPlates.cpp

#include <numeric>
#include "DetectPlates.h"


/// This function takes an input image and detects all possible license plates in it.
std::vector<PossiblePlate> detectPlatesInScene(cv::Mat&imgOriginalScene) {
    /// Vector to store the possible plates found in the scene.
    std::vector<PossiblePlate> vectorOfPossiblePlates;

    /// Convert the input image to grayscale and apply thresholding to get binary image.
    cv::Mat imgGrayscaleScene;
    cv::Mat imgThreshScene;
    preprocess(imgOriginalScene, imgGrayscaleScene, imgThreshScene);

    /// Find all possible characters in the thresholded image.
    std::vector<PossibleChar> vectorOfPossibleCharsInScene = findPossibleCharsInScene(imgThreshScene);

    /// Group the possible characters into sets of matching characters.
    std::vector<std::vector<PossibleChar>> vectorOfVectorsOfMatchingCharsInScene = findVectorOfVectorsOfMatchingChars(
            vectorOfPossibleCharsInScene);

    /// Extract possible license plates from the groups of matching characters.
    for (auto &vectorOfMatchingChars: vectorOfVectorsOfMatchingCharsInScene) {
        PossiblePlate possiblePlate = extractPlate(imgOriginalScene, vectorOfMatchingChars);
        /// If plate was found.
        if (!possiblePlate.imgPlate.empty()) vectorOfPossiblePlates.push_back(possiblePlate);
    }

    /// Print the number of possible license plates found in the image.
    std::cout << vectorOfPossiblePlates.size() << " possible plates found" << std::endl;

    /// Return the vector of possible plates found in the image.
    return vectorOfPossiblePlates;
}

std::vector<PossibleChar> findPossibleCharsInScene(cv::Mat &imgThresh) {
    /// The function first initializes an empty vector to hold the possible characters and a counter
    /// to keep track of the number of possible characters found.
    std::vector<PossibleChar> vectorOfPossibleChars;
    int intCountOfPossibleChars = 0;

    /// Create a copy of the input image for processing.
    cv::Mat imgThreshCopy;
    imgThresh.copyTo(imgThreshCopy);

    /// Find contours in the binary image.
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(imgThreshCopy, contours, cv::RETR_LIST, cv::CHAIN_APPROX_SIMPLE);

    /// Loop over all the contours found.
    for (auto &contour: contours) {
        /// Create a PossibleChar object from the contour.
        PossibleChar possibleChar(contour);
        /// Check if the possible character meets certain criteria.
        if (checkIfPossibleChar(possibleChar)) {
            /// Increment the count of possible characters.
            intCountOfPossibleChars++;
            /// Add the possible character to the vector.
            vectorOfPossibleChars.push_back(possibleChar);
        }
    }

#ifdef SHOW_STEPS
    /// Display the results if SHOW_STEPS is defined.
    std::cout << std::endl << "contours.size() = " << contours.size() << std::endl;
    std::cout << "step 2 - intCountOfValidPossibleChars = " << intCountOfPossibleChars << std::endl;
    cv::Mat imgContours(imgThresh.size(), CV_8UC3, SCALAR_BLACK);
    for (auto &contour: vectorOfPossibleChars) {
        cv::drawContours(imgContours, std::vector<std::vector<cv::Point>>{contour.contour}, 0, SCALAR_WHITE);
    }
    cv::imshow("2a", imgContours);
#endif
    return vectorOfPossibleChars;
}


PossiblePlate extractPlate(cv::Mat &imgOriginal, std::vector<PossibleChar> &vectorOfMatchingChars) {
    PossiblePlate possiblePlate; // initialize the return value

    /// Sort the matching characters from left to right based on their x position.
    std::sort(vectorOfMatchingChars.begin(), vectorOfMatchingChars.end(), PossibleChar::sortCharsLeftToRight);

    /// Calculate the center point of the plate.
    double dblPlateCenterX =
            (double) (vectorOfMatchingChars[0].intCenterX + vectorOfMatchingChars.back().intCenterX) / 2.0;
    double dblPlateCenterY =
            (double) (vectorOfMatchingChars[0].intCenterY + vectorOfMatchingChars.back().intCenterY) / 2.0;
    cv::Point2d p2dPlateCenter(dblPlateCenterX, dblPlateCenterY);

    /// Calculate the plate width and height.
    int intPlateWidth = static_cast<int>(
            (vectorOfMatchingChars.back().boundingRect.x +
             vectorOfMatchingChars.back().boundingRect.width -
             vectorOfMatchingChars[0].boundingRect.x)
            * PLATE_WIDTH_PADDING_FACTOR
    );

    double dblAverageCharHeight = std::accumulate(
            vectorOfMatchingChars.begin(),
            vectorOfMatchingChars.end(),
            0.0,
            [](double total, const PossibleChar &matchingChar) {
                return total + matchingChar.boundingRect.height;
            }
    );

    dblAverageCharHeight = dblAverageCharHeight / vectorOfMatchingChars.size();

    int intPlateHeight = static_cast<int>(dblAverageCharHeight * PLATE_HEIGHT_PADDING_FACTOR);

    /// Calculate the correction angle of the plate region.
    double dblOpposite = vectorOfMatchingChars.back().intCenterY - vectorOfMatchingChars[0].intCenterY;
    double dblHypotenuse = distanceBetweenChars(vectorOfMatchingChars[0], vectorOfMatchingChars.back());
    double dblCorrectionAngleInRad = asin(dblOpposite / dblHypotenuse);
    double dblCorrectionAngleInDeg = dblCorrectionAngleInRad * (180.0 / CV_PI);

    /// Assign the rotated rect member variable of possible plate.
    possiblePlate.rrLocationOfPlateInScene = cv::RotatedRect(
            p2dPlateCenter,
            cv::Size2f(static_cast<float>(intPlateWidth), static_cast<float>(intPlateHeight)),
            static_cast<float>(dblCorrectionAngleInDeg)
    );

    /// Perform the actual rotation.
    cv::Mat rotationMatrix;
    cv::Mat imgRotated;
    cv::Mat imgCropped;

    /// Get the rotation matrix for the calculated correction angle.
    rotationMatrix = cv::getRotationMatrix2D(
            p2dPlateCenter, dblCorrectionAngleInDeg,
            1.0
    );

    /// Rotate the entire image.
    cv::warpAffine(imgOriginal, imgRotated, rotationMatrix, imgOriginal.size());

    /// Crop out the actual plate portion of the rotated image.
    cv::getRectSubPix(
            imgRotated,
            possiblePlate.rrLocationOfPlateInScene.size, possiblePlate.rrLocationOfPlateInScene.center,
            imgCropped
    );

    /// Copy the cropped plate image into the applicable member variable of the possible plate.
    possiblePlate.imgPlate = imgCropped;

    /// Return the extracted plate
    return possiblePlate;
}


