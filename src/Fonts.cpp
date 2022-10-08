#include "pch.h"

#include "Fonts.h"

void Fonts::Scan()
{
  m_fontslist_path = CETMM::GetPaths().CETMMRoot() / "fonts.json";
  m_result = FontManager::getAvailableFonts();
  m_result->exportJson(m_fontslist_path);
}