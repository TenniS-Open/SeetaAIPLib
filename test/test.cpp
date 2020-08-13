#include "seeta_aip_engine.h"

#include <iostream>

#include "../src/this_aip_load.h"

int main() {
    // Say hello~
    std::cout << "Hey, I'm running!" << std::endl;

    using namespace seeta::aip;
    // dynamic load library
    auto lib = std::make_shared<Engine>(THIS_AIP_MODULE);

    // create instance
    Instance instance(lib,
                      Device("cpu"),
                      {"bin.bin"},
                      {});

    // create uninitialized image, initialize this object by set `image->data`
    // Use seeta::aip::cv::ImageData to convert cv::Mat easily, which is in header "seeta_aip_opencv.h"
    ImageData image(SEETA_AIP_FORMAT_U8BGR, 300, 300, 3, nullptr);

    // use instance method, get result images and objects in result.images and result.objects
    Instance::Result result = instance.forward(0, image);

    return 0;
}
