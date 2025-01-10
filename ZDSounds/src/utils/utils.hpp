#include <string>
#include <vector>

using namespace std;

wstring CharsToWStr(const char* chars);

string WStrToStr(const wstring& string);

vector<wstring> SplitStr(wstring str, const wstring& delimiter);