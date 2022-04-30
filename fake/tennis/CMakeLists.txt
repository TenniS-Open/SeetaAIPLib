# ======================== Fake TenniS ========================== #
# Script will setup FAKE_TENNIS_LIBS and FAKE_TENNIS_INCLUDE_DIRS

set(CMAKE_CXX_STANDARD 11)

FILE(GLOB_RECURSE FAKE_TENNIS_SOURCE
		${CMAKE_CURRENT_LIST_DIR}/src/*.cpp
		${CMAKE_CURRENT_LIST_DIR}/src/*.cc
		${CMAKE_CURRENT_LIST_DIR}/src/*.c
		)
add_library(FAKE_TENNIS_LIB SHARED ${FAKE_TENNIS_SOURCE})
set_target_properties(FAKE_TENNIS_LIB PROPERTIES OUTPUT_NAME tennis)
target_include_directories(FAKE_TENNIS_LIB
		PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include)
target_compile_definitions(FAKE_TENNIS_LIB PRIVATE BUILDING_TENNIS)

if (IOS)
    set_target_properties(FAKE_TENNIS_LIB PROPERTIES
        FRAMEWORK TRUE
        FRAMEWORK_VERSION A
        MACOSX_FRAMEWORK_IDENTIFIER "tennis"
        # "current version" in semantic format in Mach-O binary file
        VERSION "1.0.0"
        # "compatibility version" in semantic format in Mach-O binary file
        SOVERSION "1.0.0"
        XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer"
    )
endif()

set(FAKE_TENNIS_INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}/include PARENT_SCOPE)
set(FAKE_TENNIS_LIBS FAKE_TENNIS_LIB PARENT_SCOPE)

