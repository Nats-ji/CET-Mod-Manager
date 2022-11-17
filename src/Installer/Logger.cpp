#include "pch.h"
#include <spdlog/sinks/basic_file_sink.h>

#include "Logger.h"
#include "Version.h"

std::shared_ptr<spdlog::logger> CreateLogger()
{
  const std::string pattern = fmt::format("[%Y-%m-%d %T UTC%z] [{}] [%l] %v",CETMM_VERSION);
  const auto fileName = Installer::GetPaths().CETMMRoot() / "cet_mod_manager_asi.log";
  auto logger = spdlog::basic_logger_mt("CETMM", fileName.string());
  logger->set_pattern(pattern);
  return logger;
}
