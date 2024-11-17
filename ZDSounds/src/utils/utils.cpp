#include "pch.h"

#include ".\utils.hpp"

string WStrToStr(const wstring& wideString) {
	return string(wstring(wideString).begin(), wstring(wideString).end());
}

vector<wstring> SplitStr(wstring str, const wstring& delimiter) {
    vector<wstring> tokens;
    size_t pos = 0;
    wstring token;
    while ((pos = str.find(delimiter)) != wstring::npos) {
        token = str.substr(0, pos);
        tokens.push_back(token);
        str.erase(0, pos + delimiter.length());
    }
    tokens.push_back(str);
	return tokens;
}