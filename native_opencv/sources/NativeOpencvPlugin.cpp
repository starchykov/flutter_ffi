#include <opencv2/opencv.hpp>
#include <chrono>

/// Include other necessary header files.
#include "DetectPlates.h"
#include "PossiblePlate.h"
#include "DetectChars.h"
#include <iostream>

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32)
#define IS_WIN32
#endif

#ifdef __ANDROID__
#include <android/log.h>
#endif

#ifdef IS_WIN32
#include <windows.h>
#endif

#if defined(__GNUC__)
// Attributes to prevent 'unused' function from being removed and to make it visible
#define FUNCTION_ATTRIBUTE __attribute__((visibility("default"))) __attribute__((used))


/**
 * Draws a red rectangle around the given PossiblePlate in the input image.
 * @param imgOriginalScene Input image.
 * @param licPlate PossiblePlate object.
 * @param thickness Thickness of the lines in the rectangle.
 */
void drawRedRectangleAroundPlate(cv::Mat &imgOriginalScene, PossiblePlate &licPlate, int thickness = 2) {
    /// Get the 4 vertices of the rotated rectangle.
    cv::Point2f vertices[4];
    licPlate.rrLocationOfPlateInScene.points(vertices);

    /// Draw 4 red lines to form the rectangle.
    for (int i = 0; i < 4; i++) {
        cv::line(imgOriginalScene, vertices[i], vertices[(i + 1) % 4], cv::Scalar(0.0, 0.0, 255.0), thickness);
    }
}

#elif defined(_MSC_VER)
    /// Marking a function for export.
    #define FUNCTION_ATTRIBUTE __declspec(dllexport)
#endif

using namespace cv;
using namespace std;

long long int get_now() {
    return chrono::duration_cast<std::chrono::milliseconds>(
            chrono::system_clock::now().time_since_epoch()
    ).count();
}

void platform_log(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
#ifdef __ANDROID__
    __android_log_vprint(ANDROID_LOG_VERBOSE, "ndk", fmt, args);
#elif defined(IS_WIN32)
    char *buf = new char[4096];
    std::fill_n(buf, 4096, '\0');
    _vsprintf_p(buf, 4096, fmt, args);
    OutputDebugStringA(buf);
    delete[] buf;
#else
    vprintf(fmt, args);
#endif
    va_end(args);
}

// Avoiding name mangling
extern "C" {
FUNCTION_ATTRIBUTE

std::string result = "";

const char *version() {
    return result.c_str();
}

FUNCTION_ATTRIBUTE
void process_image(const char *inputImagePath, const char *outputImagePath, const char *basePath) {
    long long start = get_now();
    int evalInMillis;

    evalInMillis = static_cast<int>(get_now() - start);
    platform_log(basePath, evalInMillis);

    /// Attempt KNN training.
    bool knnTrainingSuccessful = loadKNNDataAndTrainKNN(basePath);

    /// If KNN training was not successful.
    if (!knnTrainingSuccessful) {
        /// Show error message and exit the program.
        std::cout << "Error: KNN training was not successful" << std::endl;
        evalInMillis = static_cast<int>(get_now() - start);
        platform_log("Error: KNN training was not successful", evalInMillis);
        return;
    }

    cv::Mat imgOriginalScene = cv::imread(inputImagePath);

    /// If unable to open image then show error message on command line and exit program.
    if (imgOriginalScene.empty()) {
        std::cout << "Error: image not read from file" << std::endl;
    }

    std::vector<PossiblePlate> plates = detectPlatesInScene(imgOriginalScene);

    /// Detect characters in plates.
    plates = detectCharsInPlates(plates);

    /// If no plates were found, inform user and exit program.
    if (plates.empty()) {
        std::cout << "No license plates were detected" << std::endl;
    }

    /// Sort the vector of possible plates in descending order (most number of chars to least number of chars).
    std::sort(plates.begin(), plates.end(), PossiblePlate::sortDescendingByNumberOfChars);

    /// Get the plate with the most recognized characters (the first plate in sorted by string length descending order).
    PossiblePlate licPlate = plates.front();

    /// Print license plate to console.
    result = licPlate.strChars;
    evalInMillis = static_cast<int>(get_now() - start);
    platform_log(result.c_str(), evalInMillis);

    /// Draw red rectangle around plate.
    drawRedRectangleAroundPlate(imgOriginalScene, licPlate, 3);

    imwrite(outputImagePath, imgOriginalScene);
}
}


