#include "pch.h"
#include <iomanip>
#include <fstream>
#include <sstream>
#include <vector>

#include "exceptions\exception.hpp"
#include "utils\utils.hpp"

#include ".\locos\chs7\chs7.hpp"
#include ".\ram.hpp"

using namespace std;


RAM::RAM() {
}

RAM::~RAM() {
	if (this->locoPtr != nullptr)
		delete this->locoPtr;
}

void RAM::Initialize() {
	try {
		this->_ReadSettingsIni();
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't read virtual settings.ini!\n" + exc.getMessage());
	}

	try {
		const wstring file = wstring(this->_rom.ADDRESSES_DIR) + this->_settingsIni.locoType + L".json";
		this->_rom.ReadAddressesFile(file, false);
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't read stations!\n" + exc.getMessage());
	}

	try {
		this->_stations = this->_rom.ReadStations(this->_settingsIni.routeName);
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't read stations!\n" + exc.getMessage());
	}

	try {
		if (this->_settingsIni.sceneryName != L"")
			this->_oncoming = this->_rom.ReadOncomings(this->_settingsIni.routeName, this->_settingsIni.sceneryName);
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't read oncoming consists!\n" + exc.getMessage());
	}

	try {
		const auto consist = this->_rom.InitializeConsist(this->_settingsIni.locoType);
		this->_consist = get<0>(consist);
		this->_passWagonUnit = get<1>(consist);
		this->_freightWagonUnit = get<2>(consist);
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't initialize consist!\n" + exc.getMessage());
	}
}

// Getters //////////

LPCWCH RAM::GetExeName() const {
	return this->_EXE_NAME;
}

bool RAM::GetConnectedToMemoryState() const {
	return this->_isConnectedToMemory.current;
}

bool RAM::GetGamePauseState() const {
	return this->_isGameOnPause.current;
}


// Processes //////////

void RAM::ReadGameValues() {
	if (this->_settingsIni.locoType == L"chs7") {
		if (this->locoPtr == nullptr)
			this->locoPtr = new CHS7();
		else
			(*(CHS7*)this->locoPtr).readRAMValues(*this, this->_rom);
	}
}

void RAM::HandleZDSWindow() {
	this->_isConnectedToMemory.current = this->_FindTask();

	if (!this->_isConnectedToMemory.current) {
		this->_isGameOnPause.current = true;
		return;
	}

	HWND windowHandle = FindWindow(nullptr, this->_WINDOW_PAUSED_NAME);
	if (windowHandle != nullptr) {
		this->_isGameOnPause.current = true;
		return;
	}

	windowHandle = FindWindow(nullptr, this->_WINDOW_NAME);
	this->_isGameOnPause.current = windowHandle == nullptr;
	this->_isGameOnPause.current;
}

bool RAM::_FindTask() {
	const HANDLE snapshotHandle = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	PROCESSENTRY32 processEntry;
	processEntry.dwSize = sizeof(PROCESSENTRY32);
	bool shouldContinueLoop = Process32First(snapshotHandle, &processEntry);

	while (shouldContinueLoop) {
		if (wcscmp(processEntry.szExeFile, this->_EXE_NAME) == 0)
			return true;
		shouldContinueLoop = Process32Next(snapshotHandle, &processEntry);
	}
	CloseHandle(snapshotHandle);
	return false;
}

HANDLE RAM::GetProcessHandle() const {
	DWORD pID = 0;
	HWND windowHandle = FindWindow(nullptr, this->_WINDOW_PAUSED_NAME);
	if (windowHandle == nullptr)
		windowHandle = FindWindow(nullptr, this->_WINDOW_NAME);
	const DWORD threadHandle = GetWindowThreadProcessId(windowHandle, &pID);
	return OpenProcess(PROCESS_ALL_ACCESS, false, pID);
}

void RAM::CloseProcessHandle(const HANDLE processHandle) const {
	CloseHandle(processHandle);
}


// Initialization //////////

void RAM::_ReadSettingsIni() {
	uintptr_t settingsIniAddress = this->ReadPointer(
		this->_rom.GetAddress((*this->_rom.GetAddressesCommon())["settingsIni"])
	);
	if (settingsIniAddress == 0)
		throw Exception(L"Invalid virtual settings.ini address: 'nullptr'");

	const wstring locoNumGlobal = this->_ReadKeyFromString(settingsIniAddress, L"LocomotiveType");
	const  wstring wagonCountStr = this->_ReadKeyFromString(settingsIniAddress, L"WagonsAmount");
	this->_settingsIni.consistName = this->_ReadKeyFromString(settingsIniAddress, L"WagsName");
	const wstring isWinterStr = this->_ReadKeyFromString(settingsIniAddress, L"Winter");
	const wstring isFreightStr = this->_ReadKeyFromString(settingsIniAddress, L"Freight");
	this->_settingsIni.routeName = this->_ReadKeyFromString(settingsIniAddress, L"RoutePath");
	const wstring direction = this->_ReadKeyFromString(settingsIniAddress, L"Route");
	const wstring sceneryNameRaw = this->_ReadKeyFromString(settingsIniAddress, L"SceneryName");

	if (locoNumGlobal == L"822")
		this->_settingsIni.locoType = L"chs7";
	else
		throw Exception(L"Invalid loco number: '" + locoNumGlobal + L"'");

	try {
		this->_settingsIni.wagonCount = stoi(wagonCountStr);
	}
	catch (...) {
		throw Exception(L"Invalid wagon count: '" + wagonCountStr + L"'");
	}

	if (isWinterStr == L"1" || isWinterStr == L"0")
		this->_settingsIni.isWinter = L"1" == isWinterStr;
	else
		throw Exception(L"Invalid winter state: '" + isWinterStr + L"'");

	if (isFreightStr == L"1" || isFreightStr == L"0")
		this->_settingsIni.isFreight = L"1" == isFreightStr;
	else
		throw Exception(L"Invalid winter state: '" + isWinterStr + L"'");

	if (direction == L"2" || direction == L"1")
		this->_settingsIni.isBackward = direction == L"2";
	else
		throw Exception(L"Invalid direction number: '" + isWinterStr + L"'");

	const bool isSceneryCorrect =
		sceneryNameRaw == L"<No>"
		|| sceneryNameRaw == L"Slow"
		|| sceneryNameRaw == L"Fast"
		|| sceneryNameRaw == L"High-speed"
		|| sceneryNameRaw.find(L".sc") != wstring::npos;
	if (isSceneryCorrect)
		this->_settingsIni.sceneryName = sceneryNameRaw;
	else
		throw Exception(L"Invalid scenery anem: '" + sceneryNameRaw + L"'");

	this->_settingsIni.locoWorkDir = L"zdsounds\\consist\\" + this->_settingsIni.locoType + L"\\";
}


// Utils //////////

wstring RAM::_ReadKeyFromString(uintptr_t address, wchar_t* const& key) {
	wstring value;
	wchar_t stringChar = 0;
	char wstringChar = 0;
	bool isKeyFound = false;
	int i = 0;

	const HANDLE processHandle = this->GetProcessHandle();
	while (i <= this->_READ_RADIUS) {
		ReadProcessMemory(processHandle, (LPCVOID)address, &stringChar, 1, NULL);

		if (stringChar != 0)
			value = value + stringChar;
		else if (value.length()) {
			if (isKeyFound)
				break;
			isKeyFound = wcsstr(value.c_str(), key) != nullptr;
			value = L"";
		}
		address++;
		i++;
	}
	this->CloseProcessHandle(processHandle);
	if (!value.length())
		throw Exception(L"Error reading key '" + wstring(key) + L"' from memory - no key found!");

	return value.substr(1);

}

wstring RAM::_ReadString(uintptr_t address, uint8_t& length) {
	wstring result;
	wchar_t stringChar = 0;

	const HANDLE processHandle = this->GetProcessHandle();
	for (uint8_t i = 0; i < length; i++) {
		ReadProcessMemory(processHandle, (LPCVOID)address, &stringChar, sizeof stringChar, NULL);
		result = result + stringChar;
		address++;
	}
	this->CloseProcessHandle(processHandle);

	return result;
}


uintptr_t RAM::ReadPointer(uintptr_t address) const {
	address = address + 3;
	stringstream hexAddressRead;
	BYTE addressPart = 0;
	uintptr_t readAddress = 0;

	const HANDLE processHandle = this->GetProcessHandle();
	for (uint8_t i = 0; i < 4; i++) {
		ReadProcessMemory(processHandle, (LPCVOID)address, &addressPart, sizeof addressPart, NULL);
		hexAddressRead << setfill('0') << setw(2) << hex << (DWORD)addressPart;
		address--;
	}
	this->CloseProcessHandle(processHandle);

	hexAddressRead >> readAddress;
	return readAddress;
}