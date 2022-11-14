#pragma once

struct FontStyle : RED4ext::IScriptable
{
    RED4ext::CClass *GetNativeType();

    FontStyle() {}
    FontStyle(RED4ext::CString aStyle, std::filesystem::path aPath): m_style{aStyle}, m_path{aPath} {}

    RED4ext::CString m_family;
    RED4ext::CString m_style;
    std::filesystem::path m_path;
};

struct FontFamily : RED4ext::IScriptable
{
    RED4ext::CClass *GetNativeType();

    FontFamily() {}
    FontFamily(RED4ext::CString aFamily): m_family{aFamily} {}

    void AddStyle(RED4ext::CString aFamily, RED4ext::CString aStyle, std::filesystem::path aPath);

    RED4ext::CString m_family;
    RED4ext::DynArray<RED4ext::Handle<FontStyle>> m_styles;
};

struct Fonts : RED4ext::IScriptable
{
    RED4ext::CClass *GetNativeType();

    void GetStyleFromPath(std::filesystem::path aPath, RED4ext::Handle<FontFamily>& aOutFontFamily, RED4ext::Handle<FontStyle>& aOutFontStyle);
    void LoadSystemFonts();
    void LoadFontFromCET();
    void SaveFontToCET();
    void PrintFonts();
    void SetFont(RED4ext::Handle<FontFamily>& aFontFamily, RED4ext::Handle<FontStyle>& aFontStyle, RED4ext::CString aGlyph, float aSize);

    RED4ext::Handle<FontFamily> m_currentFamily;
    RED4ext::Handle<FontStyle> m_currentStyle;
    std::filesystem::path m_currentPath;
    RED4ext::CString m_currentGlyph;
    float m_currentSize;
    bool m_settingChanged {false};
    RED4ext::DynArray<RED4ext::Handle<FontFamily>> m_families;
};

namespace RED4ext_Fonts
{
    void Register();
    void PostRegister();
}