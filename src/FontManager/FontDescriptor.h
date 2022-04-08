#ifndef FONT_DESCRIPTOR_H
#define FONT_DESCRIPTOR_H
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <vector>

enum FontWeight {
  FontWeightUndefined   = 0,
  FontWeightThin        = 100,
  FontWeightUltraLight  = 200,
  FontWeightLight       = 300,
  FontWeightNormal      = 400,
  FontWeightMedium      = 500,
  FontWeightSemiBold    = 600,
  FontWeightBold        = 700,
  FontWeightUltraBold   = 800,
  FontWeightHeavy       = 900
};

enum FontWidth {
  FontWidthUndefined      = 0,
  FontWidthUltraCondensed = 1,
  FontWidthExtraCondensed = 2,
  FontWidthCondensed      = 3,
  FontWidthSemiCondensed  = 4,
  FontWidthNormal         = 5,
  FontWidthSemiExpanded   = 6,
  FontWidthExpanded       = 7,
  FontWidthExtraExpanded  = 8,
  FontWidthUltraExpanded  = 9
};

struct FontDescriptor {
public:
  const char *path;
  const char *postscriptName;
  const char *family;
  const char *style;
  FontWeight weight;
  FontWidth width;
  bool italic;
  bool oblique;
  bool monospace;

  FontDescriptor(const char *path, const char *postscriptName, const char *family, const char *style, 
                 FontWeight weight, FontWidth width, bool italic, bool oblique, bool monospace) {
    this->path = copyString(path);
    this->postscriptName = copyString(postscriptName);
    this->family = copyString(family);
    this->style = copyString(style);
    this->weight = weight;
    this->width = width;
    this->italic = italic;
    this->oblique = oblique;
    this->monospace = monospace;
  }

  FontDescriptor(FontDescriptor *desc) {
    path = copyString(desc->path);
    postscriptName = copyString(desc->postscriptName);
    family = copyString(desc->family);
    style = copyString(desc->style);
    weight = desc->weight;
    width = desc->width;
    italic = desc->italic;
    oblique = desc->oblique;
    monospace = desc->monospace;
  }
  
  ~FontDescriptor() {
    if (path)
      delete path;
    
    if (postscriptName)
      delete postscriptName;
    
    if (family)
      delete family;
    
    if (style)
      delete style;
    
    postscriptName = NULL;
    family = NULL;
    style = NULL;
  }
  
  void printJson() {
    printf("{\n");

    printf("  \"path\": \"");
    printJsonString(path);
    printf("\",\n");

    printf("  \"postscriptName\": \"");
    printJsonString(postscriptName);
    printf("\",\n");

    printf("  \"family\": \"");
    printJsonString(family);
    printf("\",\n");

    printf("  \"style\": \"");
    printJsonString(style);
    printf("\",\n");

    printf("  \"weight\": %i,\n", weight);
    printf("  \"width\": %i,\n", width);

    printf("  \"italic\": ");
    printBoolean(italic);
    printf(",\n");

    printf("  \"oblique\": ");
    printBoolean(oblique);
    printf(",\n");

    printf("  \"monospace\": ");
    printBoolean(monospace);
    printf("\n}\n");
  }
  
private:
  void printBoolean(bool flag) {
    printf(flag ? "true" : "false");
  }

  void printJsonString(const char *str) {
    if (!str) {
      return;
    }
    const char *p = str;
    while (*p) {
      char c = *p;
      if (c == '\\') {
        putc('\\', stdout);
        putc('\\', stdout);
      } else if (c == '"') {
        putc('\\', stdout);
        putc('"', stdout);
      } else {
        putc(c, stdout);
      }
      p++;
    }
  }

  char *copyString(const char *input) {
    if (!input) {
      return NULL;
    }
    char *str = new char[strlen(input) + 1];
    strcpy(str, input);
    return str;
  }  
};

class ResultSet : public std::vector<FontDescriptor *> {
public:
  ~ResultSet() {
    for (ResultSet::iterator it = this->begin(); it != this->end(); it++) {
      delete *it;
    }
  }

  void printJson() {
    printf("[");
    char comma = '\n';
    for (ResultSet::iterator it = this->begin(); it != this->end(); it++) {
      putc(comma, stdout);
      printf("\n");
      comma = ',';
      (*it)->printJson();
    }
    printf("]\n");
  }
};

#endif
