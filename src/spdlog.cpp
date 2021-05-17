#include "spdlog.h"

std::shared_ptr<spdlog::logger> CreateLogger()
{
  auto logger = spdlog::basic_logger_mt("CETMM", "cyber_engine_tweaks/mods/cet_mod_manager/cet_mod_manager_asi.log");
  return logger;
}
