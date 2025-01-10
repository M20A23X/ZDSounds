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
	this->_rom = new ROM();
}

RAM::~RAM() {
	if (this->_rom != nullptr)
		delete this->_rom;
	if (this->_locoPtr != nullptr)
		delete this->_locoPtr;
}

void RAM::Initialize() {
	try {
		this->_ReadSettingsIni();
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't read virtual settings.ini! " + exc.getMessage());
	}

	try {
		const wstring file = wstring(this->_rom->ADDRESSES_DIR) + this->_settingsIni.locoType + L".json";
		this->_rom->ReadAddressesFile(file, false);
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't read stations! " + exc.getMessage());
	}

	try {
		this->_stations = this->_rom->ReadStations(this->_settingsIni.routeName);
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't read stations! " + exc.getMessage());
	}

	try {
		if (this->_settingsIni.sceneryName != L"")
			this->_oncoming = this->_rom->ReadOncomings(this->_settingsIni.routeName, this->_settingsIni.sceneryName);
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't read oncoming consists! " + exc.getMessage());
	}

	try {
		const auto consist = this->_rom->InitializeConsist(this->_settingsIni.locoType);
		this->consist = get<0>(consist);
		this->_passWagonUnit = get<1>(consist);
		this->_freightWagonUnit = get<2>(consist);
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't initialize consist! " + exc.getMessage());
	}
}

// Getters //////////
ROM* RAM::GetROM() const {
	return this->_rom;
}

LPCWCH RAM::GetExeName() const {
	return this->_EXE_NAME;
}

bool RAM::GetConnectedToMemoryState() const {
	return this->_isConnectedToMemory.current;
}

bool RAM::GetGamePauseState() const {
	return this->_isGameOnPause.current;
}

RAM::RAMValues RAM::GetRAMValues()const {
	return RAM::RAMValues(
		this->_oncoming, this->_stations, this->consist, this->_passWagonUnit, this->_freightWagonUnit, this->_locoPtr,
		this->_isConnectedToMemory.current, this->_isGameOnPause.current, this->_isRain, this->_settingsIni, this->_camera.current, this->_svt
	);
}


// Processes //////////

void RAM::ReadGameValues() {
	this->_oncoming.SavePrevious();
	this->_camera.previous = this->_camera.current;


	if (this->_settingsIni.locoType == L"chs7") {
		if (this->_locoPtr == nullptr)
			this->_locoPtr = new CHS7();
		else
			(*(CHS7*)this->_locoPtr).readRAMValues(*this, *this->_rom);
	}

	const HANDLE pHandle = this->GetProcessHandle();

	// Env
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["env"]["camera"]["env"]), &this->_camera.current.env, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["env"]["camera"]["x"]), &this->_camera.current.point.x, 4, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["env"]["camera"]["y"]), &this->_camera.current.point.y, 4, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["env"]["camera"]["z"]), &this->_camera.current.point.z, 4, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["env"]["camera"]["angleX"]), &this->_camera.current.angleX, 4, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["env"]["camera"]["angleZ"]), &this->_camera.current.angleZ, 4, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["env"]["camera"]["zoom"]), &this->_camera.current.zoom, 4, NULL);

	// SVT
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["svt"]["track"]["head"]), &this->_svt.headTrack.current, 2, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["svt"]["track"]["tail"]), &this->_svt.tailTrack, 2, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["svt"]["acceleration"]), &this->_svt.acceleration, 8, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["svt"]["speed"]), &this->_svt.speedFact, 8, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["svt"]["ordinate"]), &this->_svt.ordinate, 8, NULL);

	// Oncoming
	const wstring oncomingLoco = this->_ReadString(this->_rom->GetAddress(this->_rom->addresses["oncoming"]["loco"]), 6);
	if (oncomingLoco.rfind(L"vl11m", 0) == 0)
		this->_oncoming.consist.locoType = L"vl11m";

	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["oncoming"]["wagon-count"]), &this->_oncoming.consist.wagonCount, 1, NULL);

	double wagonLength = 0;
	uint16_t wagonLengthAddr = this->_rom->GetAddress(this->_rom->addresses["oncoming"]["wagon-length"]);
	ReadProcessMemory(pHandle, (LPCVOID)wagonLengthAddr, &this->_oncoming, 8, NULL);

	if (wagonLength > 1 && wagonLength < 50) {
		this->_oncoming.consist.wagonUnit.length = wagonLength;
		this->_oncoming.consist.length = wagonLength;

		for (uint8_t i = 0; i < this->_oncoming.consist.wagonCount; i++) {
			wagonLengthAddr += 18;
			ReadProcessMemory(pHandle, (LPCVOID)wagonLengthAddr, &wagonLength, 8, NULL);
			this->_oncoming.consist.length += wagonLength;
		}
	}

	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["oncoming"]["track"]), &this->_oncoming.track, 2, NULL);

	//Misc
	ReadProcessMemory(pHandle, (LPCVOID)this->_rom->GetAddress(this->_rom->addresses["misc"]["rain"]), &this->_isRain, 1, NULL);

	this->CloseProcessHandle(pHandle);
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

HWND RAM::GetWindowHandle() const {
	HWND windowHandle = FindWindow(nullptr, this->_WINDOW_PAUSED_NAME);
	if (windowHandle == nullptr)
		windowHandle = FindWindow(nullptr, this->_WINDOW_NAME);
	return windowHandle;
}

HANDLE RAM::GetProcessHandle() const {
	DWORD pID = 0;
	HWND windowHandle = this->GetWindowHandle();
	const DWORD threadHandle = GetWindowThreadProcessId(windowHandle, &pID);
	return OpenProcess(PROCESS_ALL_ACCESS, false, pID);
}

void RAM::CloseProcessHandle(const HANDLE processHandle) const {
	CloseHandle(processHandle);
}


// Initialization //////////

void RAM::_ReadSettingsIni() {
	uintptr_t settingsIniAddress = this->ReadPointer(
		this->_rom->GetAddress(this->_rom->addresses["settings-ini"])
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

wstring RAM::_ReadString(uintptr_t address, uint8_t length) {
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