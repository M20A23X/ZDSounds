#pragma once

#include <tuple>
#include <Windows.h>
#include <sstream>
#include <TlHelp32.h>
#include <queue>
#include "rapidjson\document.h"

#include "types\types.hpp"

#include ".\rom.hpp"

using namespace std;


class LocoBase;
class RAM {
public:
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
	struct SVT : SavePrev {
		float  acceleration = 0;		// ускорение (м/ч^2)
		uint16_t speedFact = 0;			// скорость (факт,км/ч)
		float
			speed = 0,				// скорость (км/ч)
			ordinate = 0;			// ордината
		Value<uint16_t> headTrack;		// трек головы
		uint16_t tailTrack = 0;			// трек хвоста				
		bool  isMovingOpposite = false;	// направление движения


		void SavePrevious() override {
			this->headTrack.previous = this->headTrack.current;
		}
	};

	// Camera
	struct Camera {
		EnvEnum env = CABIN;	// состояние (внутри/снаружи - 0/1)	
		Point point;			// координаты центра		
		float
			angleZ = 0,
			angleX = 0,
			zoom = 0;

		Camera() {}
		Camera(const Camera& camera)
			: env{ camera.env}, point{ camera.point }, angleX{ camera.angleX }, angleZ{ camera.angleZ } {
		}
	};

	struct RAMValues {
	public:
		// ROM
		const ROM::Oncoming* oncoming;
		const ROM::Stations* stations;
		const ROM::Consist* consist;
		const ROM::ConsistUnit
			* passWagonUnit,
			* freightWagonUnit;

		// RAM
		const LocoBase* locoPtr = nullptr;
		const bool
			isConnectedToMemory,
			isGameOnPause,
			isRain;
		const SettingsIni* settingsIni;
		const Camera* camera;
		const SVT* svt;

	public:
		RAMValues(
			const ROM::Oncoming& oncoming, const ROM::Stations& stations, const ROM::Consist& consist, const ROM::ConsistUnit& passWagonUnit,
			const ROM::ConsistUnit& freightWagonUnit, const LocoBase* locoPtr, const bool& isConnectedToMemory, const bool& isGameOnPause,
			const bool& isRain, const SettingsIni& settingsIni, const Camera& camera, const  SVT& svt
		)
			: oncoming{ &oncoming }, stations{ &stations }, consist{ &consist }, passWagonUnit{ &passWagonUnit }, freightWagonUnit{ &freightWagonUnit },
			locoPtr{ locoPtr }, isConnectedToMemory{ isConnectedToMemory }, isGameOnPause{ isGameOnPause }, isRain{ isRain }, settingsIni{ &settingsIni },
			camera{ &camera }, svt{ &svt } {
		}
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
	ROM::Consist consist;
	ROM::ConsistUnit
		_passWagonUnit,
		_freightWagonUnit;

	// RAM
	LocoBase* _locoPtr = nullptr;

	bool _isRain;
	Value<bool>
		_isConnectedToMemory,
		_isGameOnPause;

	SettingsIni _settingsIni;
	Value<Camera> _camera;
	SVT _svt;


public:
	RAM();
	~RAM();
	void Initialize();

	// Getters 
	LPCWCH GetExeName() const;
	bool GetConnectedToMemoryState() const;
	bool GetGamePauseState() const;
	RAMValues GetRAMValues() const;

	// Initialization
private:
	void _ReadSettingsIni();

	// Processes
public:
	HANDLE GetProcessHandle() const;
	void CloseProcessHandle(const HANDLE) const;
	void HandleZDSWindow();
	void ReadGameValues();
private:
	bool _FindTask();

	// Utils
public:
	uintptr_t ReadPointer(uintptr_t) const;
private:
	wstring _ReadKeyFromString(uintptr_t, wchar_t* const&);
	wstring _ReadString(uintptr_t, uint8_t&);
};
