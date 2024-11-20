#pragma once

#include <string>

#include "..\..\..\types\types.hpp"

using namespace std;


// Constants
const string ADDRESSES_DIR = ".\\..\\..\\..\\assets\\static\\addresses\\";

struct LocoBase {
	// Vars
public:
	bool
		isCouple = false,
		IsCombinedOpened = false,
		isWhistleActive = false,
		isHornActive = false;

	Value<bool>
		windowsOpenState[2] = { false,false },
		isBatteryCharge0,
		isBatteryCharge1,
		isVHPress,
		isVHSPress,
		isMainSwitchActive,
		isWipersActive,
		isVilignanceCheck,
		isHighlightsActive,
		isEPVActive,
		isSlipping;

	uint8_t
		reversorState = 0;

	Value<uint8_t>
		crane395State,
		crane254State;

	float
		amperageEPB = 0.0f,
		wipersDegree = 0.0f;

	// Pneumatics
	float
		brakeLinePressure = 0.0f,
		balanceTankPressure = 0.0f,
		pressureLine = 0.0f,
		auxBrakeTankPressure = 0.0f;

	void readRAMValues();
};

struct LocoElectricBase : public LocoBase {
	// Vars
public:
	uint8_t
		positionSection0 = 0,
		shuntState = 0,
		pantographFront = 0,
		pantographBack = 0;

	float
		voltageLoco = 0.0f,
		amperageTE = 0.0f,
		amperageUltimateTE = 0.0f;

	// MV, MK
	bool
		isMVsActive = false,
		isMVsTEActive = false;

	// Methods
public:
	void readRAMValues();
};

