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
enum FileValueEnum { LOCO_SECITONS_COUNT = 0, TRACK_LIST_TRACK = 7, TRACK_LIST_ORDINATE = 10 };


// Constructor //////////
RAM::RAM() {
	this->ReadAddressesFile(this->ADDRESSES_FILE);
}

// Getters //////////

// GetExeName
LPCWCH RAM::GetExeName() const {
	return this->EXE_NAME;
}

// CheckConnectedToMemory
bool RAM::GetConnectedToMemoryState() const {
	return this->isConnectedToMemory.current;
}

// CheckOnPause
bool RAM::GetGamePauseState() const {
	return this->isGameOnPause.current;
}

// Processes //////////

// HandleZDSWindow
void RAM::HandleZDSWindow() {
	this->isConnectedToMemory.current = this->FindTask();

	if (!this->isConnectedToMemory.current) {
		this->isGameOnPause.current = true;
		return;
	}

	HWND windowHandle = FindWindow(nullptr, this->WINDOW_PAUSED_NAME);
	if (windowHandle != nullptr) {
		this->isGameOnPause.current = true;
		return;
	}

	windowHandle = FindWindow(nullptr, this->WINDOW_NAME);
	this->isGameOnPause.current = windowHandle == nullptr;
}

// FindTask
bool RAM::FindTask() {
	const HANDLE snapshotHandle = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	PROCESSENTRY32 processEntry;
	processEntry.dwSize = sizeof(PROCESSENTRY32);
	bool shouldContinueLoop = Process32First(snapshotHandle, &processEntry);

	while (shouldContinueLoop) {
		if (wcscmp(processEntry.szExeFile, this->EXE_NAME) == 0)
			return true;
		shouldContinueLoop = Process32Next(snapshotHandle, &processEntry);
	}
	CloseHandle(snapshotHandle);
	return false;
}

// GetHandles
HANDLE RAM::GetProcessHandle() const {
	DWORD pID = 0;
	HWND windowHandle = FindWindow(nullptr, this->WINDOW_PAUSED_NAME);
	if (windowHandle == nullptr)
		windowHandle = FindWindow(nullptr, this->WINDOW_NAME);
	const DWORD threadHandle = GetWindowThreadProcessId(windowHandle, &pID);
	return OpenProcess(PROCESS_ALL_ACCESS, false, pID);
}

// CloseProcessHandle
void RAM::CloseProcessHandle(const HANDLE processHandle) const {
	CloseHandle(processHandle);
}


// Initialization //////////

// ReadSettingsIni
void RAM::ReadSettingsIni() {
	uintptr_t settingsIniAddress = ReadPointer(GetAddress("settingsIni"));
	if (settingsIniAddress == 0)
		return;

	const wstring locoNumGlobal = this->ReadKeyFromString(settingsIniAddress, L"LocomotiveType");
	const  wstring wagonCountStr = this->ReadKeyFromString(settingsIniAddress, L"WagonsAmount");
	this->settingsIni.consistName = this->ReadKeyFromString(settingsIniAddress, L"WagsName");
	this->settingsIni.isWinter = L"1" == this->ReadKeyFromString(settingsIniAddress, L"Winter");
	this->settingsIni.isFreight = L"1" == this->ReadKeyFromString(settingsIniAddress, L"Freight");
	this->settingsIni.routeName = this->ReadKeyFromString(settingsIniAddress, L"RoutePath");
	const wstring sceneryNameRaw = this->ReadKeyFromString(settingsIniAddress, L"SceneryName");
	const wstring direction = this->ReadKeyFromString(settingsIniAddress, L"Route");

	if (locoNumGlobal == L"822")
		this->settingsIni.locoType = L"chs7";
	if (wagonCountStr.length())
		this->settingsIni.wagonCount = stoi(wagonCountStr);
	if (wcsstr(L".sc", sceneryNameRaw.c_str()) != nullptr)
		this->settingsIni.sceneryName = sceneryNameRaw;
	this->settingsIni.isBackward = direction == L"2";
	this->settingsIni.locoWorkDir = L"TWS/Consist/" + this->settingsIni.locoType + L"/";
}

// InitializeConsist
void RAM::InitializeConsist() {
	this->consist.locoType = this->settingsIni.locoType;

	this->consist.locoUnit = ReadConsistUnit(this->consist.locoType, &consist.sectionCount, true);
	this->passWagonUnit = ReadConsistUnit(L"passenger");
	this->freightWagonUnit = ReadConsistUnit(L"freight");

	uint8_t wagonAxesCount = 0;
	uint16_t wagonLength = 0;
	if (consist.type == ConsistTypeEnum::PASSENGER) {
		wagonLength = passWagonUnit.length;
		wagonAxesCount = passWagonUnit.axesCount;
	}
	else if (consist.type = ConsistTypeEnum::FREIGHT) {
		wagonLength = freightWagonUnit.length;
		wagonAxesCount = freightWagonUnit.axesCount;
	}

	consist.axesCount = consist.locoUnit.axesCount + consist.wagonCount * wagonAxesCount;
	consist.length = wagonLength * consist.wagonCount + consist.locoUnit.length;
}

// ReadAddressesFile
void RAM::ReadAddressesFile(const wstring& file) {
	ifstream fileStream(file, ifstream::binary);
	if (!fileStream.good())
		throw Exception(L"Error reading file: " + file);

	string addressesJson((istreambuf_iterator<char>(fileStream)), istreambuf_iterator<char>());
	fileStream.close();

	this->addresses;
	this->addresses.Parse(addressesJson.c_str());

	if (this->addresses.HasParseError()) {
		const wstring  message = L"Error parsing json '" + file + L"': " + to_wstring(this->addresses.GetParseError());
		throw Exception(message);
	}
}

// GetAddress
uintptr_t RAM::GetAddress(const char* key) const {
	istringstream converter(this->addresses[key].GetString());
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

	const wstring file = L"routes/" + this->settingsIni.routeName + L"/route" + to_wstring(this->settingsIni.isBackward + 1) + L".trk";

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
RAM::ConsistUnit& RAM::ReadConsistUnit(const wstring& dir, uint8_t* sectionCountPtr, const bool& isLoco) {
	ConsistUnit unit;
	uint8_t idxShift = uint8_t(isLoco);

	wstring file = L"zdsounds\\consist\\" + dir + L"\\entity\\axes.dat";
	wstring line;

	wifstream fileStream(file);
	if (!fileStream.good())
		throw Exception(L"Error reading file '" + file + L"'!");

	getline(fileStream, line);
	fileStream.close();

	vector<wstring> tokens = SplitStr(line, L" ");

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
void RAM::ReadOncoming() {}


// Utils //////////

// ReadKeyFromString
wstring RAM::ReadKeyFromString(uintptr_t address, wchar_t* const& key) {
	wstring value;
	wchar_t stringChar = 0;
	char wstringChar = 0;
	bool isKeyFound = false;
	int i = 0;

	const HANDLE processHandle = this->GetProcessHandle();
	while (i <= this->READ_RADIUS) {
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

// ReadString
wstring RAM::ReadString(uintptr_t address, uint8_t& length) {
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


// ReadPointer
uintptr_t RAM::ReadPointer(uintptr_t address) {
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