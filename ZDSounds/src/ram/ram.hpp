#pragma once

#include <Windows.h>
#include <sstream>
#include <TlHelp32.h>
#include <queue>
#include "rapidjson\document.h"

#include "..\types\types.hpp"

using namespace std;

class RAM {
	/// Types //////////
private:
	// Virtual settings.ini
	struct SettingsIni {
		uint8_t
			locoNumber = 0,
			wagonCount = 0;
		string
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
	struct Station {
		uint8_t	start = 0;
		uint8_t	end = 0;
	};

	struct Stations {
		Station* stationsArr = nullptr;
		uint8_t	 stationCount = 0;
		bool	 isOnStation = false;
	};

	// Displacement-speed-time
	struct SVT {
		float		acceleretion = 0.0f;
		uint16_t	speedFact = 0;
		float		speed = 0.0f;
		float		ordinate = 0.0f;
		uint16_t	headTrack = 0;
		uint16_t	tailTrack = 0;
		bool		isMovingOpposite = false;
	};

	// Consist
	enum ConsistTypeEnum { PASSENGER, FREIGHT, RESERV };

	struct ConsistUnit {
		uint8_t	axesCount = 0;
		uint8_t* axesArr = nullptr;
		uint8_t	length = 0;
	};

	struct Consist {
		ConsistTypeEnum	type = ConsistTypeEnum::PASSENGER;
		string locoType;
		uint8_t
			sectionCount = 0,
			length = 0,
			wagonCount = 0,
			axesCount = 0;
		ConsistUnit
			locoUnit,
			wagonUnit;
	};

	// Oncoming
	struct Oncoming {
		Consist consist;
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
	struct Camera {
		EnvEnum	env = CABIN;
		Point point;
		float
			angleZ = 0.0f,
			angleX = 0.0f,
			zoom = 0.0f;
	};

	/// Vars //////////
private:
	LPCWSTR EXE_NAME = L"Launcher.exe";
	LPCWSTR WINDOW_NAME = L"ZDSimulator55.008";
	LPCWSTR WINDOW_PAUSED_NAME = L"ZDSimulator55.008 [Paused]";
	LPCWSTR ADDRESSES_FILE = L"assets\\static\\addresses\\common.json";

	const int READ_RADIUS = 6666;

	rapidjson::Document addresses;


	Value<bool>
		isConnectedToMemory,
		isGameOnPause,
		isRain;

	Value<Camera> camera;
	SettingsIni settingsIni;
	SVT svt;
	Consist consist;
	Oncoming oncoming;
	ConsistUnit
		PassWagonUnit,
		FreightWagonUnit;

	/// Methods //////////
private:
	// Utils
	bool FindTask();
	HANDLE GetProcessHandle() const;
	void CloseProcessHandle(const HANDLE processHandle) const;

	string ReadKeyFromString(uintptr_t address, char* const& key);
	string ReadString(uintptr_t address, uint8_t& length);

	uintptr_t ReadPointer(uintptr_t address);
	uintptr_t RAM::GetAddress(const char* key) const;

public:
	// Constructor
	RAM();

	// Getters 
	LPCWCH GetExeName() const;
	bool CheckConnectedToMemory() const;
	bool CheckOnPause() const;

	// RAM common
	void HandleZDSWindow();

	void ReadStations();
	void ReadSettingsIni();

	void ReadCommonValues();
	void InitializeConsist();
	uint32_t ReadOrdinateByTrack(const uint16_t& track) const;
	ConsistUnit ReadConsistUnit(const string& dir, const bool& isLoco = true);
	void ReadOncoming();

	// Utils
	void ReadAddressesFile(LPCWSTR file);
};