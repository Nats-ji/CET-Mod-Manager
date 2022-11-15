// adopted from https://github.com/foliojs/font-manager

#define WINVER 0x0600
#include "pch.h"
#include "FontManager.h"

namespace FontManager
{
  // throws a JS error when there is some exception in DirectWrite
  #define HR(hr) \
    if (FAILED(hr)) { printf("Font loading error at %s:%i\n", __FILE__, __LINE__); throw "Font loading error"; }

  char *utf16ToUtf8(const WCHAR *input) {
    unsigned int len = WideCharToMultiByte(CP_UTF8, 0, input, -1, NULL, 0, NULL, NULL);
    char *output = new char[len + 1];
    output[len] = '\0';
    WideCharToMultiByte(CP_UTF8, 0, input, -1, output, len, NULL, NULL);
    return output;
  }

  // returns the index of the user's locale in the set of localized strings
  unsigned int getLocaleIndex(IDWriteLocalizedStrings *strings) {
    unsigned int index = 0;
    BOOL exists = false;

    HR(strings->FindLocaleName(L"en-us", &index, &exists));
    if (!exists) {
      index = 0;
    }
    return index;
  }

  // gets a localized string for a font
  char *getString(IDWriteFont *font, DWRITE_INFORMATIONAL_STRING_ID string_id) {
    char *res = NULL;
    IDWriteLocalizedStrings *strings = NULL;

    BOOL exists = false;
    HR(font->GetInformationalStrings(
      string_id,
      &strings,
      &exists
    ));

    if (exists) {
      unsigned int index = getLocaleIndex(strings);
      unsigned int len = 0;
      WCHAR *str = NULL;

      HR(strings->GetStringLength(index, &len));
      str = new WCHAR[len + 1];

      HR(strings->GetString(index, str, len + 1));

      // convert to utf8
      res = utf16ToUtf8(str);
      delete str;

      strings->Release();
    }

    if (!res) {
      res = new char[1];
      res[0] = '\0';
    }

    return res;
  }

  FontDescriptor *resultFromFont(IDWriteFont *font) {
    FontDescriptor *res = NULL;
    IDWriteFontFace *face = NULL;
    unsigned int numFiles = 0;

    HR(font->CreateFontFace(&face));

    // get the font files from this font face
    IDWriteFontFile *files = NULL;
    HR(face->GetFiles(&numFiles, NULL));
    HR(face->GetFiles(&numFiles, &files));

    // return the first one
    if (numFiles > 0) {
      IDWriteFontFileLoader *loader = NULL;
      IDWriteLocalFontFileLoader *fileLoader = NULL;
      unsigned int nameLength = 0;
      const void *referenceKey = NULL;
      unsigned int referenceKeySize = 0;
      WCHAR *name = NULL;

      HR(files[0].GetLoader(&loader));

      // check if this is a local font file
      HRESULT hr = loader->QueryInterface(__uuidof(IDWriteLocalFontFileLoader), (void **)&fileLoader);
      if (SUCCEEDED(hr)) {
        // get the file path
        HR(files[0].GetReferenceKey(&referenceKey, &referenceKeySize));
        HR(fileLoader->GetFilePathLengthFromKey(referenceKey, referenceKeySize, &nameLength));

        name = new WCHAR[nameLength + 1];
        HR(fileLoader->GetFilePathFromKey(referenceKey, referenceKeySize, name, nameLength + 1));

        char *psName = utf16ToUtf8(name);
        char *postscriptName = getString(font, DWRITE_INFORMATIONAL_STRING_POSTSCRIPT_NAME);
        char *family = getString(font, DWRITE_INFORMATIONAL_STRING_WIN32_FAMILY_NAMES);
        char *style = getString(font, DWRITE_INFORMATIONAL_STRING_WIN32_SUBFAMILY_NAMES);

        // this method requires windows 7, so we need to cast to an IDWriteFontFace1
        IDWriteFontFace1 *face1 = static_cast<IDWriteFontFace1 *>(face);
        bool monospace = face1->IsMonospacedFont() == TRUE;

        res = new FontDescriptor(
          psName,
          postscriptName,
          family,
          style,
          (FontWeight) font->GetWeight(),
          (FontWidth) font->GetStretch(),
          font->GetStyle() == DWRITE_FONT_STYLE_ITALIC,
          font->GetStyle() == DWRITE_FONT_STYLE_OBLIQUE,
          monospace
        );

        delete psName;
        delete name;
        delete postscriptName;
        delete family;
        delete style;
        fileLoader->Release();
      }

      loader->Release();
    }

    face->Release();
    files->Release();

    return res;
  }

  ResultSet *getAvailableFonts() {
    ResultSet *res = new ResultSet();
    int count = 0;

    IDWriteFactory *factory = NULL;
    HR(DWriteCreateFactory(
      DWRITE_FACTORY_TYPE_SHARED,
      __uuidof(IDWriteFactory),
      reinterpret_cast<IUnknown**>(&factory)
    ));

    // Get the system font collection.
    IDWriteFontCollection *collection = NULL;
    HR(factory->GetSystemFontCollection(&collection));

    // Get the number of font families in the collection.
    int familyCount = collection->GetFontFamilyCount();

    // track postscript names we've already added
    // using a set so we don't get any duplicates.
    std::unordered_set<std::string> psNames;

    for (int i = 0; i < familyCount; i++) {
      IDWriteFontFamily *family = NULL;

      // Get the font family.
      HR(collection->GetFontFamily(i, &family));
      int fontCount = family->GetFontCount();

      for (int j = 0; j < fontCount; j++) {
        IDWriteFont *font = NULL;
        HR(family->GetFont(j, &font));

        FontDescriptor *result = resultFromFont(font);
        if (psNames.count(result->postscriptName) == 0) {
          res->push_back(result);
          psNames.insert(result->postscriptName);
        }
        font->Release();
      }

      family->Release();
    }

    collection->Release();
    factory->Release();

    return res;
  }
}