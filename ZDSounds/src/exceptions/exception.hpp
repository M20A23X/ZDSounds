#include <sstream>

#include "utils\utils.hpp"

using namespace std;

class Exception : exception {
public:
	Exception(const wstring message)
		: exception(
			string((const char*)&message[0], sizeof(wchar_t) / sizeof(char) * message.size()).c_str()
		) {
	}

	wstring getMessage() const {
		wstringstream str;
		str << this->what();
		return str.str();
	}

	System::String^ getStringMessage() const {
		return gcnew System::String(this->getMessage().c_str());
	}
};