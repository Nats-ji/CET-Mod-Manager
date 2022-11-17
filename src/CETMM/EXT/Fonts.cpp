#include "pch.h"
#include "FontManager/FontManager.h"
#include "Fonts.h"

void FontFamily::AddStyle(RED4ext::CString aFamily, RED4ext::CString aStyle, std::filesystem::path aPath)
{
    auto fontstyleType = RED4ext::CRTTISystem::Get()->GetClass("FontStyle");
    auto fontstyle = reinterpret_cast<FontStyle*>(fontstyleType->AllocInstance());
    fontstyleType->ConstructCls(fontstyle);
    fontstyle->m_family = aFamily;
    fontstyle->m_style = aStyle;
    fontstyle->m_path = aPath;
    m_styles.EmplaceBack(fontstyle);
}

// RED4ext::Handle<FontStyle> &Fonts::GetStyleFromPath(std::filesystem::path aPath)
// {
//     for(auto &family : m_families)
//     {
//         RED4ext::Handle<FontStyle> *it;
//         if (aPath.empty()) // return default family when path is empty
//         {
//             it = std::find_if(family->m_styles.begin(), family->m_styles.end(), [](const RED4ext::Handle<FontStyle>& obj) {return obj->m_path.empty();});
//         }
//         else
//         {
//             it = std::find_if(family->m_styles.begin(), family->m_styles.end(), [&aPath](const RED4ext::Handle<FontStyle>& obj) { if (!obj->m_path.empty()) return std::filesystem::equivalent(obj->m_path, aPath); else return false;});
//         }
//         if (it != family->m_styles.end())
//         {
//             fmt::print("{}, {}\n", it->GetPtr()->m_path.string(), aPath.string());
//             return *it;
//         }
//     }
// }

void Fonts::GetStyleFromPath(std::filesystem::path aPath, RED4ext::Handle<FontFamily>& aOutFontFamily, RED4ext::Handle<FontStyle>& aOutFontStyle)
{
    for(auto &family : m_families)
    {
        RED4ext::Handle<FontStyle> *it;
        if (aPath.empty()) // return default family when path is empty
        {
            it = std::find_if(family->m_styles.begin(), family->m_styles.end(), [](const RED4ext::Handle<FontStyle>& obj) {return obj->m_path.empty();});
        }
        else
        {
            it = std::find_if(family->m_styles.begin(), family->m_styles.end(), [&aPath](const RED4ext::Handle<FontStyle>& obj) { if (!obj->m_path.empty()) return std::filesystem::equivalent(obj->m_path, aPath); else return false;});
        }
        if (it != family->m_styles.end())
        {
            fmt::print("{}, {}\n", it->GetPtr()->m_path.string(), aPath.string());
            aOutFontStyle = *it;
            aOutFontFamily = family;
            return;
        }
    }
}

void Fonts::LoadSystemFonts()
{
    // add default fontfamily
    {
        auto fontfamilyType = RED4ext::CRTTISystem::Get()->GetClass("FontFamily");
        auto fontfamily = reinterpret_cast<FontFamily*>(fontfamilyType->AllocInstance());
        fontfamilyType->ConstructCls(fontfamily);
        fontfamily->m_family = "Default";
        fontfamily->AddStyle("Default", "Regular", "");
        m_families.EmplaceBack(fontfamily);
    }

    // load system fonts
    auto result = FontManager::getAvailableFonts();
    for(auto const &font : *result)
    {
        // check if family already exists
        RED4ext::CString family_name = font->family;
        auto it = std::find_if(m_families.begin(), m_families.end(), [&family_name](const RED4ext::Handle<FontFamily>& obj) {return obj->m_family == family_name;});
        if (it == m_families.end())
        { // family doesn't exist
            auto fontfamilyType = RED4ext::CRTTISystem::Get()->GetClass("FontFamily");
            auto fontfamily = reinterpret_cast<FontFamily*>(fontfamilyType->AllocInstance());
            fontfamilyType->ConstructCls(fontfamily);
            fontfamily->m_family = family_name;
            fontfamily->AddStyle(font->family, font->style, font->path);
            m_families.EmplaceBack(fontfamily);
        } 
        else
        { // family exists
            it->GetPtr()->AddStyle(font->family, font->style, font->path);
        }
    }
}

void Fonts::LoadFontFromCET()
{
    auto cet_config_path = CETMM::GetPaths().CETConfig();
    std::ifstream file(cet_config_path);
    if (!file.is_open())
    {
        spdlog::error("Couldn't open CET config file at: {}.", cet_config_path.string());
        return;
    }

    nlohmann::json cet_config = nlohmann::json::parse(file);
    file.close();

    m_currentGlyph = cet_config["font_glyph_ranges"].get<std::string>().c_str();
    m_currentPath = cet_config["font_path"].get<std::filesystem::path>();
    m_currentSize = cet_config["font_size"].get<float>();
    GetStyleFromPath(m_currentPath, m_currentFamily, m_currentStyle);

    fmt::print("currentglyph: {}, currentPath: {}, currentSize: {}, currentFamily: {}\n", m_currentGlyph.c_str(), m_currentPath.string(), m_currentSize, m_currentFamily->m_family.c_str());
}

void Fonts::SaveFontToCET()
{
    if (m_settingChanged)
    {
        auto cet_config_path = CETMM::GetPaths().CETConfig();
        std::fstream file;
        file.open(cet_config_path, std::fstream::in | std::fstream::out);
        if (!file.is_open())
        {
            spdlog::error("Couldn't open CET config file at: {}.", cet_config_path.string());
            return;
        }

        nlohmann::json cet_config = nlohmann::json::parse(file);
        std::filesystem::resize_file(cet_config_path, 0);
        file.seekg(0);
        
        cet_config["font_glyph_ranges"] = m_currentGlyph.c_str();
        cet_config["font_path"] = m_currentPath.string();
        cet_config["font_size"] = m_currentSize;

        file << cet_config.dump(4) << std::endl;
        file.close();
    }
}

void Fonts::SetFont(RED4ext::Handle<FontFamily>& aFontFamily, RED4ext::Handle<FontStyle>& aFontStyle, RED4ext::CString aGlyph, float aSize)
{
    m_currentFamily = aFontFamily;
    m_currentPath = aFontStyle->m_path;
    m_currentGlyph = aGlyph;
    m_currentSize = aSize;
    m_settingChanged = true;
    fmt::print("Font Set!\ncurrentglyph: {}, currentPath: {}, currentSize: {}, currentFamily: {}\n", m_currentGlyph.c_str(), m_currentPath.string(), m_currentSize, m_currentFamily->m_family.c_str());
    SaveFontToCET();
}

void Fonts::PrintFonts()
{
    fmt::print("There are total {} font families.\n", m_families.size);
    for(auto const &family : m_families)
    {
        fmt::print("{}:\n", family->m_family.c_str());
        for(auto const &style : family->m_styles)
        {
            fmt::print("\t{}:\t{}\n", style->m_style.c_str(), style->m_path.string());
        }
    }
}
// red4ext impl

RED4ext::TTypedClass<Fonts> cls_fonts("Fonts");
RED4ext::CClass* Fonts::GetNativeType()
{
    return &cls_fonts;
}

RED4ext::TTypedClass<FontFamily> cls_fontfamily("FontFamily");
RED4ext::CClass* FontFamily::GetNativeType()
{
    return &cls_fontfamily;
}

RED4ext::TTypedClass<FontStyle> cls_fontstyle("FontStyle");
RED4ext::CClass* FontStyle::GetNativeType()
{
    return &cls_fontstyle;
}

void red4ext_SetFont(RED4ext::IScriptable* aContext, RED4ext::CStackFrame* aFrame, void* aOut, int64_t a4)
{
    RED4ext::Handle<FontFamily> fontfamily;
    RED4ext::Handle<FontStyle> fontstyle;
    RED4ext::CString glyph;
    float size;
    RED4ext::GetParameter(aFrame, &fontfamily);
    RED4ext::GetParameter(aFrame, &fontstyle);
    RED4ext::GetParameter(aFrame, &glyph);
    RED4ext::GetParameter(aFrame, &size);
    aFrame->code++;
    CETMM::GetFonts().SetFont(fontfamily, fontstyle, glyph, size);
}

void RED4ext_Fonts::Register()
{
    RED4ext::CNamePool::Add("Fonts");
    RED4ext::CNamePool::Add("FontFamily");
    RED4ext::CNamePool::Add("FontStyle");
    RED4ext::CNamePool::Add("handle:Fonts");
    RED4ext::CNamePool::Add("handle:FontFamily");
    RED4ext::CNamePool::Add("handle:FontStyle");
    RED4ext::CNamePool::Add("array:handle:FontFamily");
    RED4ext::CNamePool::Add("array:handle:FontStyle");
    RED4ext::CRTTISystem::Get()->RegisterType(&cls_fonts);
    RED4ext::CRTTISystem::Get()->RegisterType(&cls_fontfamily);
    RED4ext::CRTTISystem::Get()->RegisterType(&cls_fontstyle);
}

void RED4ext_Fonts::PostRegister()
{
  auto rtti = RED4ext::CRTTISystem::Get();

    // Fonts
    {
        auto func_setFont = RED4ext::CClassStaticFunction::Create(&cls_fonts, "SetFont", "SetFont", &red4ext_SetFont, {.isNative = true, .isStatic = true});
        func_setFont->AddParam("handle:FontFamily", "fontFamily");
        func_setFont->AddParam("handle:FontStyle", "fontStyle");
        func_setFont->AddParam("String", "glyph");
        func_setFont->AddParam("Float", "size");
        cls_fonts.RegisterFunction(func_setFont);

        auto currentFamily = RED4ext::CProperty::Create(rtti->GetType("handle:FontFamily"), "currentFamily", nullptr, offsetof(Fonts, m_currentFamily));
        auto currentStyle = RED4ext::CProperty::Create(rtti->GetType("handle:FontStyle"), "currentStyle", nullptr, offsetof(Fonts, m_currentStyle));
        auto currentGlyph = RED4ext::CProperty::Create(rtti->GetType("String"), "currentGlyph", nullptr, offsetof(Fonts, m_currentGlyph));
        auto currentSize = RED4ext::CProperty::Create(rtti->GetType("Float"), "currentSize", nullptr, offsetof(Fonts, m_currentSize));
        auto families = RED4ext::CProperty::Create(rtti->GetType("array:handle:FontFamily"), "families", nullptr, offsetof(Fonts, m_families));
        auto settingChanged = RED4ext::CProperty::Create(rtti->GetType("Bool"), "settingChanged", nullptr, offsetof(Fonts, m_settingChanged));
        cls_fonts.props.PushBack(currentFamily);
        cls_fonts.props.PushBack(currentStyle);
        cls_fonts.props.PushBack(currentGlyph);
        cls_fonts.props.PushBack(currentSize);
        cls_fonts.props.PushBack(families);
        cls_fonts.props.PushBack(settingChanged);
    }

    // FontFamily
    {
        auto family = RED4ext::CProperty::Create(rtti->GetType("String"), "family", nullptr, offsetof(FontFamily, m_family));
        auto styles = RED4ext::CProperty::Create(rtti->GetType("array:handle:FontStyle"), "styles", nullptr, offsetof(FontFamily, m_styles));
        cls_fontfamily.props.PushBack(family);
        cls_fontfamily.props.PushBack(styles);
    }

    // FontStyle
    {
        auto family = RED4ext::CProperty::Create(rtti->GetType("String"), "family", nullptr, offsetof(FontStyle, m_family));
        auto style = RED4ext::CProperty::Create(rtti->GetType("String"), "style", nullptr, offsetof(FontStyle, m_style));
        cls_fontstyle.props.PushBack(family);
        cls_fontstyle.props.PushBack(style);
    }
}