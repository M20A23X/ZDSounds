#include "pch.h"

#include ".\utils.hpp"

string WStrToStr(const wstring& wideString) {
	return string(wstring(wideString).begin(), wstring(wideString).end());
}

vector<string> SplitStr(string str, const string& delimiter) {
    vector<string> tokens;
    size_t pos = 0;
    string token;
    while ((pos = str.find(delimiter)) != string::npos) {
        token = str.substr(0, pos);
        tokens.push_back(token);
        str.erase(0, pos + delimiter.length());
    }
    tokens.push_back(str);
	return tokens;
}