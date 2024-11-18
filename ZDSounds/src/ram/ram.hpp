#pragma once

#include <tuple>
#include <Windows.h>
#include <sstream>
#include <TlHelp32.h>
#include <queue>
#include "rapidjson\document.h"

#include "types\types.hpp"

using namespace std;

class RAM {
private:
	// Virtual settings.ini
	struct _SettingsIni {
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

	// Station borders from start_kilometers.dat
	struct _Stations {
		vector<tuple<uint16_t, uint16_t>> stationsArr;
		bool isOnStation = false;
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

	// Consist
	enum _ConsistTypeEnum { PASSENGER, FREIGHT, RESERV };

	struct _ConsistUnit {
		uint8_t	axesCount = 0;
		uint16_t
			length = 0,
			* axesArr = nullptr;

		~_ConsistUnit() {
			if (this->axesArr != nullptr)
				delete this->axesArr;
		}
	};

	struct _Consist {
		_ConsistTypeEnum	type = _ConsistTypeEnum::PASSENGER;
		wstring locoType;
		uint16_t length = 0;
		uint8_t
			sectionCount = 0,
			wagonCount = 0,
			axesCount = 0;
		_ConsistUnit
			locoUnit,
			wagonUnit;
	};

	// Oncoming
	struct _Oncoming {
		_Consist _consist;
		bool
			shouldReinit = false,
			shouldReset = false;
		float
			ordinateDelta = 0.0f,
			ordinateDiff = 0.0f,
			ordinate = 0.0f,
			speed = 0.0f;
		Value<uint16_t> track;
		queue<float> speeds;

		OncomingStatusEnum	status = OncomingStatusEnum::COMING;
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
	const LPCWSTR _ADDRESSES_FILE = L".\\zdsounds\\assets\\static\\addresses\\common.json";
	const LPCWSTR _EXE_NAME = L"Launcher.exe";
	const LPCWSTR _WINDOW_NAME = L"ZDSimulator55.008";
	const LPCWSTR _WINDOW_PAUSED_NAME = L"ZDSimulator55.008 [Paused]";

	const int _READ_RADIUS = 6666;

	rapidjson::Document _addresses;

	Value<bool>
		_isConnectedToMemory,
		_isGameOnPause,
		_isRain;

	Value<_Camera> _camera;
	_SettingsIni _settingsIni;
	_Stations _stations;
	_SVT _svt;
	_Consist _consist;
	_Oncoming _oncoming;
	_ConsistUnit
		_passWagonUnit,
		_freightWagonUnit;

public:
	RAM();

	// Getters 
	LPCWCH GetExeName() const;
	bool GetConnectedToMemoryState() const;
	bool GetGamePauseState() const;

	// Initialization
public:
	void ReadStations();
	void ReadSettingsIni();
	void InitializeConsist();
private:
	void _ReadAddressesFile(const wstring&);
	uintptr_t _GetAddress(const char*) const;

	// Processes
public:
	void HandleZDSWindow();
private:
	bool _FindTask();
	HANDLE _GetProcessHandle() const;
	void _CloseProcessHandle(const HANDLE) const;

	// Common
public:
	void ReadCommonValues();
	uint32_t ReadOrdinateByTrack(const uint16_t&) const;
	_ConsistUnit& ReadConsistUnit(const wstring&, uint8_t* = nullptr, const bool& = false);
	void ReadOncoming();

	// Utils
private:
	wstring _ReadKeyFromString(uintptr_t, wchar_t* const&);
	wstring _ReadString(uintptr_t, uint8_t&);
	uintptr_t _ReadPointer(uintptr_t);
};