#pragma once

#include "Paths.h"
#include "Update.h"

class Installer
{
public:
  static void Initialize();
  static void Shutdown();
  static Installer& Get();

  static const Paths& GetPaths();
  static Update& GetUpdate();

  Installer(const Installer&) = delete;
  Installer(Installer&&) = delete;
  Installer& operator=(const Installer&) = delete;
  Installer& operator=(Installer&&) = delete;

private:
  Installer() {}
  ~Installer() {}

  Paths m_paths;
  Update m_update;
};