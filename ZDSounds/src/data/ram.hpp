#pragma once

#include <tuple>
#include <Windows.h>
#include <sstream>
#include <TlHelp32.h>
#include <queue>
#include "rapidjson\document.h"

#include "rom.hpp"
#include "types\types.hpp"

using namespace std;

class RAM {
private:
	// Virtual settings.ini
	struct SettingsIni {
		uint8_t wagonCount = 0;
		wstring
			locoType,
			routeName,
			sceneryName,
			consistName,
			locoWorkDir;
		bool
			isFreight = false,
			isWinter = false,
			isBackward = false;
	};

	// Displacement-speed-time
	struct _SVT {
		float		acceleretion = 0.0f;
		uint16_t	speedFact = 0;
		float		speed = 0.0f;
		float		ordinate = 0.0f;
		uint16_t	headTrack = 0;
		uint16_t	tailTrack = 0;
		bool		isMovingOpposite = false;
	};

	// Camera
	struct _Camera {
		EnvEnum	env = CABIN;
		Point point;
		float
			angleZ = 0.0f,
			angleX = 0.0f,
			zoom = 0.0f;
	};

private:
	const LPCWSTR _EXE_NAME = L"Launcher.exe";
	const LPCWSTR _WINDOW_NAME = L"ZDSimulator55.008";
	const LPCWSTR _WINDOW_PAUSED_NAME = L"ZDSimulator55.008 [Paused]";

	const int _READ_RADIUS = 6666;

	// ROM
	ROM _rom;
	ROM::Oncoming _oncoming;
	ROM::Stations _stations;
	ROM::Consist _consist;
	ROM::ConsistUnit
		_passWagonUnit,
		_freightWagonUnit;

	// RAM
	Value<bool>
		_isConnectedToMemory,
		_isGameOnPause,
		_isRain;
	SettingsIni _settingsIni;
	Value<_Camera> _camera;
	_SVT _svt;


public:
	RAM();
	void Initialize();

	// Getters 
	LPCWCH GetExeName() const;
	bool GetConnectedToMemoryState() const;
	bool GetGamePauseState() const;

	// Initialization
private:
	void _ReadSettingsIni();

	// Processes
public:
	void HandleZDSWindow();
	void ReadCommonValues();
private:
	bool _FindTask();
	HANDLE _GetProcessHandle() const;
	void _CloseProcessHandle(const HANDLE) const;

	// Utils
private:
	wstring _ReadKeyFromString(uintptr_t, wchar_t* const&);
	wstring _ReadString(uintptr_t, uint8_t&);
	uintptr_t _ReadPointer(uintptr_t);
};