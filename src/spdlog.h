#pragma once

#include "pch.h"
#include <spdlog/sinks/basic_file_sink.h>

std::shared_ptr<spdlog::logger> CreateLogger();