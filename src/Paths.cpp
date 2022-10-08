#include "pch.h"
#include "Paths.h"

const std::filesystem::path& Paths::GameRoot() const
{
  return m_gameRoot;
}

const std::filesystem::path& Paths::Archives() const
{
  return m_archives;
}

const std::filesystem::path& Paths::Plugins() const
{
  return m_plugins;
}

const std::filesystem::path& Paths::Red4Ext() const
{
  return m_red4ext;
}

const std::filesystem::path& Paths::RedScript() const
{
  return m_redscript;
}

const std::filesystem::path& Paths::CETMods() const
{
  return m_cetmods;
}

const std::filesystem::path& Paths::CETScripts() const
{
  return m_cetscripts;
}

const std::filesystem::path& Paths::CETMMRoot() const
{
  return m_cetmmRoot;
}

const std::filesystem::path& Paths::Config() const
{
  return m_config;
}

const std::filesystem::path& Paths::AuthCode() const
{
  return m_authCode;
}

const std::filesystem::path& Paths::RandNames() const
{
  return m_randNames;
}

Paths::Paths()
{
  TCHAR exePathBuf[MAX_PATH] = { 0 };
  GetModuleFileName(GetModuleHandle(nullptr), exePathBuf, std::size(exePathBuf));
  m_exe = exePathBuf;
  m_exeRoot = m_exe.parent_path();
  m_gameRoot = m_exeRoot.parent_path().parent_path();
  m_archives = m_gameRoot / "archive" / "pc" / "mod";
  m_plugins = m_exeRoot / "plugins";
  m_red4ext = m_gameRoot / "red4ext" / "plugins";
  m_redscript = m_gameRoot / "r6" / "scripts";
  m_cetmods = m_plugins / "cyber_engine_tweaks" / "mods";
  m_cetscripts = m_plugins / "cyber_engine_tweaks" / "scripts";
  m_cetmmRoot = m_cetmods / "cet_mod_manager";
  m_config = m_cetmmRoot / "config.json";
  m_authCode = m_cetmmRoot / "authCode.lua";
  m_randNames = m_cetmmRoot / "coreFunc.lua";
  
#ifdef DEBUG
  spdlog::info("m_exe: {}", m_exe.string());
  spdlog::info("m_exeRoot: {}", m_exeRoot.string());
  spdlog::info("m_gameRoot: {}", m_gameRoot.string());
  spdlog::info("m_archives: {}", m_archives.string());
  spdlog::info("m_plugins: {}", m_plugins.string());
  spdlog::info("m_red4ext: {}", m_red4ext.string());
  spdlog::info("m_redscript: {}", m_redscript.string());
  spdlog::info("m_cetmods: {}", m_cetmods.string());
  spdlog::info("m_cetscripts: {}", m_cetscripts.string());
  spdlog::info("m_cetmmRoot: {}", m_cetmmRoot.string());
  spdlog::info("m_config: {}", m_config.string());
#endif // DEBUG
}