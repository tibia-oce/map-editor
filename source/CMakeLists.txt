# *****************************************************************************
# Project remeres
# *****************************************************************************
project(remeres)

find_package(asio CONFIG REQUIRED)
find_package(fmt CONFIG REQUIRED)
find_package(OpenGL REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(Threads REQUIRED)
find_package(wxWidgets COMPONENTS html aui gl adv core net base CONFIG REQUIRED)
find_package(ZLIB REQUIRED)
find_package(pugixml CONFIG REQUIRED)
find_package(Boost REQUIRED COMPONENTS spirit utility asio)
find_package(LibArchive REQUIRED)

# Conditionally find and use GLFW instead of GLUT on macOS ARM
if(APPLE AND CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
    find_package(glfw3 CONFIG REQUIRED)
    add_definitions(-DUSE_GLFW)
else()
    find_package(GLUT REQUIRED)
    add_definitions(-DUSE_FREEGLUT)
endif()

option(TOGGLE_BIN_FOLDER "Use build/bin folder for generate compilation files" OFF)
option(OPTIONS_ENABLE_OPENMP "Enable Open Multi-Processing support." ON)
option(DEBUG_LOG "Enable Debug Log" OFF)
option(BUILD_STATIC_LIBRARY "Build using static libraries" ON)
option(SPEED_UP_BUILD_UNITY "Compile using build unity for speed up build" ON)

# Build static libs
if(BUILD_STATIC_LIBRARY)
	log_option_enabled("STATIC_LIBRARY")

	if(MSVC)
		set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")
	elseif(UNIX AND NOT APPLE)
		set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
	elseif(APPLE)
		set(CMAKE_FIND_LIBRARY_SUFFIXES ".a" ".dylib")
	endif()
else()
	log_option_disabled("STATIC_LIBRARY")
endif()

# === DEBUG LOG ===
# cmake -DDEBUG_LOG=ON ..
if(DEBUG_LOG)
	add_definitions(-DDEBUG_LOG=ON)
	log_option_enabled("DEBUG LOG")
else()
	log_option_disabled("DEBUG LOG")
endif(DEBUG_LOG)

if (MSVC)
	add_executable(${PROJECT_NAME} "" ../cmake/remeres.rc)

	if(BUILD_STATIC_LIBRARY)
		set(CMAKE_CXX_FLAGS_RELEASE "/MT")
		set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "/MT")
		set(CMAKE_CXX_FLAGS_DEBUG "/MTd")
		set_property(TARGET ${PROJECT_NAME} PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
	endif()

	target_compile_options(${PROJECT_NAME} PUBLIC /MP /FS /Zf /EHsc )
else()
	add_executable(${PROJECT_NAME} "")
endif()

# === OpenMP ===
if(OPTIONS_ENABLE_OPENMP)
	log_option_enabled("openmp")
	find_package(OpenMP)
	if(OpenMP_CXX_FOUND)
		target_link_libraries(${PROJECT_NAME} PUBLIC OpenMP::OpenMP_CXX)
	endif()
else()
	log_option_disabled("openmp")
endif()

# === IPO ===
check_ipo_supported(RESULT result OUTPUT output)
if(result)
	set_property(TARGET ${PROJECT_NAME} PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
else()
	message(WARNING "IPO is not supported: ${output}")
endif()

# === PRECOMPILED HEADER ===
target_precompile_headers(${PROJECT_NAME} PRIVATE main.h)

# === UNITY BUILD (compile time reducer) ===
if(SPEED_UP_BUILD_UNITY)
	set_target_properties(${PROJECT_NAME} PROPERTIES UNITY_BUILD ON)
	log_option_enabled("Build unity for speed up compilation")
endif()

# === Target Sources ===
target_sources(${PROJECT_NAME}
	PRIVATE
	about_window.cpp
	action.cpp
	application.cpp
	artprovider.cpp
	basemap.cpp
	brush.cpp
	brush_tables.cpp
	browse_tile_window.cpp
	positionctrl.cpp
	carpet_brush.cpp
	client_version.cpp
	common.cpp
	common_windows.cpp
	complexitem.cpp
	container_properties_window.cpp
	copybuffer.cpp
	creature_brush.cpp
	creature.cpp
	creatures.cpp
	dat_debug_view.cpp
	dcbutton.cpp
	doodad_brush.cpp
	editor.cpp
	editor_tabs.cpp
	eraser_brush.cpp
	extension.cpp
	extension_window.cpp
	find_item_window.cpp
	filehandle.cpp
	graphics.cpp
	ground_brush.cpp
	gui.cpp
	house_brush.cpp
	house.cpp
	house_exit_brush.cpp
	iomap.cpp
	iomap_otbm.cpp
	#iomap_otmm.cpp
	item_attributes.cpp
	item.cpp
	items.cpp
	light_drawer.cpp
	live_action.cpp
	live_client.cpp
	live_peer.cpp
	live_server.cpp
	live_socket.cpp
	live_tab.cpp
	main_menubar.cpp
	main_toolbar.cpp
	map.cpp
	map_display.cpp
	map_drawer.cpp
	map_region.cpp
	map_tab.cpp
	map_window.cpp
	materials.cpp
	minimap_window.cpp
	mkpch.cpp
	mt_rand.cpp
	net_connection.cpp
	numbertextctrl.cpp
	old_properties_window.cpp
	palette_brushlist.cpp
	palette_common.cpp
	palette_creature.cpp
	palette_house.cpp
	palette_waypoints.cpp
	palette_window.cpp
	pngfiles.cpp
	preferences.cpp
	process_com.cpp
	properties_window.cpp
	raw_brush.cpp
	replace_items_window.cpp
	result_window.cpp
	rme_net.cpp
	selection.cpp
	settings.cpp
	spawn_brush.cpp
	spawn.cpp
	table_brush.cpp
	templatemap76-74.cpp
	templatemap81.cpp
	templatemap854.cpp
	templatemapclassic.cpp
	tile.cpp
	tileset.cpp
    add_tileset_window.cpp
    add_item_window.cpp
    tileset_window.cpp
	town.cpp
	updater.cpp
	wall_brush.cpp
	waypoint_brush.cpp
	waypoints.cpp
	welcome_dialog.cpp
	json/json_spirit_reader.cpp
	json/json_spirit_value.cpp
	json/json_spirit_writer.cpp
)

# === Include Directories and Libraries ===
target_include_directories(${PROJECT_NAME}
	PRIVATE
	${CMAKE_SOURCE_DIR}/source
	${OPENGL_INCLUDE_DIR}
	${ZLIB_INCLUDE_DIR}
)

if(APPLE AND CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
    target_include_directories(${PROJECT_NAME} PRIVATE ${glfw3_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME}
        PRIVATE
        ${OPENGL_LIBRARIES}
        glfw
        ${ZLIB_LIBRARIES}
        fmt::fmt
        asio::asio
        nlohmann_json::nlohmann_json
        pugixml::pugixml
        wx::core wx::base wx::aui wx::gl wx::html wx::net
        Boost::spirit Boost::utility Boost::asio
        LibArchive::LibArchive
    )
else()
    target_include_directories(${PROJECT_NAME} PRIVATE ${GLUT_INCLUDE_DIRS})
    target_link_libraries(${PROJECT_NAME}
        PRIVATE
        ${OPENGL_LIBRARIES}
        ${GLUT_LIBRARIES}
        ${ZLIB_LIBRARIES}
        fmt::fmt
        asio::asio
        nlohmann_json::nlohmann_json
        pugixml::pugixml
        wx::core wx::base wx::aui wx::gl wx::html wx::net
        Boost::spirit Boost::utility Boost::asio
        LibArchive::LibArchive
    )
endif()

# === Output Directory ===
if (TOGGLE_BIN_FOLDER)
	set_target_properties(${PROJECT_NAME}
			PROPERTIES
			RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
	)
else()
	set_target_properties(${PROJECT_NAME}
			PROPERTIES
			RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/"
	)
endif()
