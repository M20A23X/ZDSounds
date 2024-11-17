#include "pch.h"
#include <iomanip>
#include <fstream>
#include <sstream>

#include ".\ram.hpp"

using namespace std;
/// Private ////////////////////

// Utils //////////

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
HANDLE RAM::GetProcessHandle()const {
	DWORD pID = 0;
	HWND windowHandle = FindWindow(nullptr, this->WINDOW_PAUSED_NAME);
	if (windowHandle == nullptr)
		windowHandle = FindWindow(nullptr, this->WINDOW_NAME);
	const DWORD threadHandle = GetWindowThreadProcessId(windowHandle, &pID);
	return OpenProcess(PROCESS_ALL_ACCESS, false, pID);
}


void RAM::CloseProcessHandle(const HANDLE processHandle) const {
	CloseHandle(processHandle);
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

uintptr_t RAM::GetAddress(const char* key) const {
	istringstream converter(this->addresses[key].GetString());
	uintptr_t address;
	converter >> std::hex >> address;
	return address;
}

// ReadString
string RAM::ReadString(uintptr_t address, uint8_t& length) {
	string result;
	char stringChar = 0;

	const HANDLE processHandle = this->GetProcessHandle();
	for (uint8_t i = 0; i < length; i++) {
		ReadProcessMemory(processHandle, (LPCVOID)address, &stringChar, sizeof stringChar, NULL);
		result = result + stringChar;
		address++;
	}
	this->CloseProcessHandle(processHandle);

	return result;
}


string RAM::ReadKeyFromString(uintptr_t address, char* const& key) {
	string value;
	char stringChar = 0;
	bool isKeyFound = false;
	int i = 0;

	const HANDLE processHandle = this->GetProcessHandle();
	while (i <= this->READ_RADIUS) {
		ReadProcessMemory(processHandle, (LPCVOID)address, &stringChar, sizeof stringChar, NULL);

		if (stringChar != 0)
			value = value + stringChar;
		else if (value.length()) {
			if (isKeyFound)
				return value.substr(1);

			isKeyFound = strstr(value.c_str(), key) != nullptr;
			value = "";
		}
		address++;
		i++;
	}
	this->CloseProcessHandle(processHandle);

	return "";
}


/// Public ////////////////////

// Constructor //////////
RAM::RAM() {
	this->ReadAddressesFile(this->ADDRESSES_FILE);
}

// Getters //////////

// ReadString
LPCWCH RAM::GetExeName() const {
	return this->EXE_NAME;
}

// ReadString
bool RAM::CheckConnectedToMemory() const {
	return this->isConnectedToMemory.current;
}

// ReadString
bool RAM::CheckOnPause() const {
	return this->isGameOnPause.current;
}


// RAM Common //////////

// ReadString
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

// ReadSettingsIni
void RAM::ReadSettingsIni() {
	uintptr_t settingsIniAddress = ReadPointer(GetAddress("settingsIni"));
	if (settingsIniAddress == 0)
		return;

	string locoNumGlobal = this->ReadKeyFromString(settingsIniAddress, "LocomotiveType");
	this->settingsIni.wagonCount = stoi(this->ReadKeyFromString(settingsIniAddress, "WagonsAmount"));
	this->settingsIni.consistName = this->ReadKeyFromString(settingsIniAddress, "WagsName");
	this->settingsIni.isWinter = "1" == this->ReadKeyFromString(settingsIniAddress, "Winter");
	this->settingsIni.isFreight = "1" == this->ReadKeyFromString(settingsIniAddress, "Freight");
	string direction = this->ReadKeyFromString(settingsIniAddress, "Route");
	this->settingsIni.routeName = this->ReadKeyFromString(settingsIniAddress, "RoutePath");
	string sceneryNameRaw = this->ReadKeyFromString(settingsIniAddress, "SceneryName");

	if (locoNumGlobal == "822") {
		this->settingsIni.locoType = "CHS7";
	}
	if (strstr(".sc", sceneryNameRaw.c_str()) != nullptr)
		this->settingsIni.sceneryName = sceneryNameRaw;
	this->settingsIni.isBackward = direction == "2";
}

// InitializeConsist
void RAM::InitializeConsist() {}

// ReadOrdinateByTrack
uint32_t RAM::ReadOrdinateByTrack(const uint16_t& track) const {
	return 0;
}

// ReadConsistUnit
RAM::ConsistUnit RAM::ReadConsistUnit(const string& dir, const bool& isLoco) {
	ConsistUnit unit;
	return unit;
}

// ReadOncoming
void RAM::ReadOncoming() {}

// ReadValues
void RAM::ReadCommonValues() {
}


// Utils //////////

// ReadAddressesFile
void RAM::ReadAddressesFile(LPCWSTR file) {
	wstring errorStr = L"";

	ifstream addressesFile(file, ifstream::binary);
	if (!addressesFile.good()) {
		errorStr = L"Error reading file: ";
		errorStr = errorStr + file;
		throw errorStr;
	}

	string addressesJson((istreambuf_iterator<char>(addressesFile)), istreambuf_iterator<char>());
	addressesFile.close();

	this->addresses;
	this->addresses.Parse(addressesJson.c_str());

	if (this->addresses.HasParseError()) {
		errorStr = L"Error parsing json '" + errorStr + file + L"': " + to_wstring(this->addresses.GetParseError());
		throw errorStr;
	}
}
