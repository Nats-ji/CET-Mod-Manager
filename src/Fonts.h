#pragma once

#include "FontManager/FontManager.h"

class Fonts
{
public:
  void Scan();

private:
  std::filesystem::path m_fontslist_path;
  FontManager::ResultSet *m_result;
};
