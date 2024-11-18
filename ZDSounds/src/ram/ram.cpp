#include "pch.h"
#include <iomanip>
#include <fstream>
#include <sstream>
#include <vector>

#include "exceptions\exception.hpp"
#include "utils\utils.hpp"

#include ".\ram.hpp"

using namespace std;

// Misc
enum FileValueEnum {
	LOCO_SECITONS_COUNT = 0,
	STATION_KILOMETER_START = 1,
	STATION_KILOMETER_END = 2,
	ONCOMING_SPEED = 3,
	TRACK_LIST_TRACK = 7,
	TRACK_LIST_ORDINATE = 10
};


RAM::RAM() {
	this->_ReadAddressesFile(this->_ADDRESSES_FILE);
}

// Getters //////////

// GetExeName
LPCWCH RAM::GetExeName() const {
	return this->_EXE_NAME;
}

// CheckConnectedToMemory
bool RAM::GetConnectedToMemoryState() const {
	return this->_isConnectedToMemory.current;
}

// CheckOnPause
bool RAM::GetGamePauseState() const {
	return this->_isGameOnPause.current;
}

// Processes //////////

// HandleZDSWindow
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
}

// FindTask
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

// GetHandles
HANDLE RAM::_GetProcessHandle() const {
	DWORD pID = 0;
	HWND windowHandle = FindWindow(nullptr, this->_WINDOW_PAUSED_NAME);
	if (windowHandle == nullptr)
		windowHandle = FindWindow(nullptr, this->_WINDOW_NAME);
	const DWORD threadHandle = GetWindowThreadProcessId(windowHandle, &pID);
	return OpenProcess(PROCESS_ALL_ACCESS, false, pID);
}

// CloseProcessHandle
void RAM::_CloseProcessHandle(const HANDLE processHandle) const {
	CloseHandle(processHandle);
}


// Initialization //////////

// ReadSettingsIni
void RAM::ReadSettingsIni() {
	uintptr_t settingsIniAddress = _ReadPointer(_GetAddress("settingsIni"));
	if (settingsIniAddress == 0)
		return;

	const wstring locoNumGlobal = this->_ReadKeyFromString(settingsIniAddress, L"LocomotiveType");
	const  wstring wagonCountStr = this->_ReadKeyFromString(settingsIniAddress, L"WagonsAmount");
	this->_settingsIni.consistName = this->_ReadKeyFromString(settingsIniAddress, L"WagsName");
	this->_settingsIni.isWinter = L"1" == this->_ReadKeyFromString(settingsIniAddress, L"Winter");
	this->_settingsIni.isFreight = L"1" == this->_ReadKeyFromString(settingsIniAddress, L"Freight");
	this->_settingsIni.routeName = this->_ReadKeyFromString(settingsIniAddress, L"RoutePath");
	const wstring sceneryNameRaw = this->_ReadKeyFromString(settingsIniAddress, L"SceneryName");
	const wstring direction = this->_ReadKeyFromString(settingsIniAddress, L"Route");

	if (locoNumGlobal == L"822")
		this->_settingsIni.locoType = L"chs7";
	if (wagonCountStr.length())
		this->_settingsIni.wagonCount = stoi(wagonCountStr);
	if (sceneryNameRaw.find(L".sc") != wstring::npos)
		this->_settingsIni.sceneryName = sceneryNameRaw;
	this->_settingsIni.isBackward = direction == L"2";
	this->_settingsIni.locoWorkDir = L"zdsounds\\consist\\" + this->_settingsIni.locoType + L"\\";
}

// InitializeConsist
void RAM::InitializeConsist() {
	this->_consist.locoType = this->_settingsIni.locoType;

	this->_consist.locoUnit = ReadConsistUnit(this->_consist.locoType, &_consist.sectionCount, true);
	this->_passWagonUnit = ReadConsistUnit(L"passenger");
	this->_freightWagonUnit = ReadConsistUnit(L"freight");

	uint8_t wagonAxesCount = 0;
	uint16_t wagonLength = 0;
	if (_consist.type == _ConsistTypeEnum::PASSENGER) {
		wagonLength = _passWagonUnit.length;
		wagonAxesCount = _passWagonUnit.axesCount;
	}
	else if (_consist.type = _ConsistTypeEnum::FREIGHT) {
		wagonLength = _freightWagonUnit.length;
		wagonAxesCount = _freightWagonUnit.axesCount;
	}

	_consist.axesCount = _consist.locoUnit.axesCount + _consist.wagonCount * wagonAxesCount;
	_consist.length = wagonLength * _consist.wagonCount + _consist.locoUnit.length;
}

// ReadStations
void RAM::ReadStations() {
	const wstring file = L"routes\\" + this->_settingsIni.routeName + L"\\start_kilometers.dat";

	wifstream fileStream(file, ifstream::binary);
	if (!fileStream.good())
		throw Exception(L"Error reading file: " + file);

	wstring line;

	while (!fileStream.eof()) {
		getline(fileStream, line);
		if (line == L"\n")
			continue;

		const vector<wstring> tokens = SplitStr(line, L" ");
		if (tokens.size() >= 3) {
			tuple<uint16_t, uint16_t> entry(stoi(tokens[STATION_KILOMETER_START]), stoi(tokens[STATION_KILOMETER_END]));
			this->_stations.stationsArr.push_back(entry);
		}
	}

	fileStream.close();
}

// ReadAddressesFile
void RAM::_ReadAddressesFile(const wstring& file) {
	ifstream fileStream(file, ifstream::binary);
	if (!fileStream.good())
		throw Exception(L"Error reading file: " + file);

	string addressesJson((istreambuf_iterator<char>(fileStream)), istreambuf_iterator<char>());
	fileStream.close();

	this->_addresses.Parse(addressesJson.c_str());

	if (this->_addresses.HasParseError()) {
		const wstring  message = L"Error parsing json '" + file + L"': " + to_wstring(this->_addresses.GetParseError());
		throw Exception(message);
	}
}

// GetAddress
uintptr_t RAM::_GetAddress(const char* key) const {
	istringstream converter(this->_addresses[key].GetString());
	uintptr_t address;
	converter >> std::hex >> address;
	return address;
}


// Common //////////

// ReadCommonValues
void RAM::ReadCommonValues() {
}


// ReadOrdinateByTrack
uint32_t RAM::ReadOrdinateByTrack(const uint16_t& track) const {
	wstring line;
	wstring ordinate;

	const wstring file = L"routes\\" + this->_settingsIni.routeName + L"\\route" + to_wstring(this->_settingsIni.isBackward + 1) + L".trk";

	wifstream fileStream(file);
	if (!fileStream.good())
		throw Exception(L"Error reading file: " + file);

	while (!fileStream.eof()) {
		getline(fileStream, line);
		const vector<wstring> tokens = SplitStr(line, L",");

		if (stoi(tokens[TRACK_LIST_TRACK]) == track) {
			wstring ordinateStr = tokens[TRACK_LIST_ORDINATE];
			ordinateStr.pop_back();
			const uint32_t ordinate = stoi(ordinateStr);
			fileStream.close();
			return ordinate;
		}
	}

	throw Exception(L"Error reading ordinate by track - " + to_wstring(track) + L"track not found!");
}

// ReadConsistUnit
RAM::_ConsistUnit& RAM::ReadConsistUnit(const wstring& dir, uint8_t* sectionCountPtr, const bool& isLoco) {
	_ConsistUnit unit;
	uint8_t idxShift = uint8_t(isLoco);

	wstring file = L"zdsounds\\consist\\" + dir + L"\\entity\\axes.dat";
	wstring line;

	wifstream fileStream(file);
	if (!fileStream.good())
		throw Exception(L"Error reading file '" + file + L"'!");

	getline(fileStream, line);
	fileStream.close();

	const vector<wstring> tokens = SplitStr(line, L" ");

	if (tokens.size() == 0)
		throw Exception(L"Error initializing consist unit - no data!");

	unit.axesCount = static_cast<uint8_t>(tokens.size()) - idxShift;
	unit.axesArr = new uint16_t[unit.axesCount];

	if (isLoco)
		*sectionCountPtr = stoi(tokens[LOCO_SECITONS_COUNT]);

	for (uint8_t i = idxShift; i < tokens.size() - 1; i++) {
		unit.axesArr[i - idxShift] = stoi(tokens[i]);
		unit.length = unit.length + unit.axesArr[i - idxShift];
	}
	unit.length = unit.length + unit.axesArr[unit.axesCount - 1];

	return unit;
}

// ReadOncoming
void RAM::ReadOncoming() {
	if (this->_settingsIni.sceneryName == L"")
		return;

	const wstring file = L"routes\\" + this->_settingsIni.routeName + L"\\scenaries\\" + this->_settingsIni.sceneryName;

	wifstream fileStream(file);
	if (!fileStream.good())
		throw Exception(L"Error reading file "" + file + L""!");

	wstring line;

	while (!fileStream.eof() && line != L"[oncoming traffic]")
		getline(fileStream, line);

	while (line != L"[static]") {
		getline(fileStream, line);
		const vector<wstring> tokens = SplitStr(line, L"\t");
		if (tokens[0].length() == 4)
			this->_oncoming.speeds.push(stof(tokens[ONCOMING_SPEED]));
	}

	fileStream.close();
}


// Utils //////////

// ReadKeyFromString
wstring RAM::_ReadKeyFromString(uintptr_t address, wchar_t* const& key) {
	wstring value;
	wchar_t stringChar = 0;
	char wstringChar = 0;
	bool isKeyFound = false;
	int i = 0;

	const HANDLE processHandle = this->_GetProcessHandle();
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
	this->_CloseProcessHandle(processHandle);
	if (!value.length())
		throw Exception(L"Error reading key '" + wstring(key) + L"' from memory - no key found!");

	return value.substr(1);

}

// ReadString
wstring RAM::_ReadString(uintptr_t address, uint8_t& length) {
	wstring result;
	wchar_t stringChar = 0;

	const HANDLE processHandle = this->_GetProcessHandle();
	for (uint8_t i = 0; i < length; i++) {
		ReadProcessMemory(processHandle, (LPCVOID)address, &stringChar, sizeof stringChar, NULL);
		result = result + stringChar;
		address++;
	}
	this->_CloseProcessHandle(processHandle);

	return result;
}


// ReadPointer
uintptr_t RAM::_ReadPointer(uintptr_t address) {
	address = address + 3;
	stringstream hexAddressRead;
	BYTE addressPart = 0;
	uintptr_t readAddress = 0;

	const HANDLE processHandle = this->_GetProcessHandle();
	for (uint8_t i = 0; i < 4; i++) {
		ReadProcessMemory(processHandle, (LPCVOID)address, &addressPart, sizeof addressPart, NULL);
		hexAddressRead << setfill('0') << setw(2) << hex << (DWORD)addressPart;
		address--;
	}
	this->_CloseProcessHandle(processHandle);

	hexAddressRead >> readAddress;
	return readAddress;
}