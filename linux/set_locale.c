#include <locale.h>

void setNumericLocaleToC() {
    setlocale(LC_NUMERIC, "C");
}
