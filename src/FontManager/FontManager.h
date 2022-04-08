#pragma once

#include "pch.h"
#include "FontDescriptor.h"

namespace FontManager
{
  char *utf16ToUtf8(const WCHAR *input);
  unsigned int getLocaleIndex(IDWriteLocalizedStrings *strings);
  char *getString(IDWriteFont *font, DWRITE_INFORMATIONAL_STRING_ID string_id);
  FontDescriptor *resultFromFont(IDWriteFont *font);
  ResultSet *getAvailableFonts();
}