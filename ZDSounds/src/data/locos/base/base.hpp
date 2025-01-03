#pragma once

#include <string>
#include "rapidjson\document.h"

#include "types\types.hpp"

#include "data\ram.hpp"


using namespace std;


const string ADDRESSES_DIR = ".\\..\\..\\..\\assets\\static\\addresses\\";

class RAM;
class ROM;
class LocoBase {
public:
	bool
		isCouple = false,
		isCombinedOpened = false,
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
		amperageEPB = 0,
		wipersDegree = 0;

	// Pneumatics
	float
		brakeLinePressure = 0,
		balanceTankPressure = 0,
		pressureLine = 0,
		auxBrakeTankPressure = 0;

public:
	virtual ~LocoBase() = 0;

	virtual	void readRAMValues(const RAM&, const ROM&);
};

class LocoElectricBase : public LocoBase {
public:
	uint8_t
		positionSection0 = 0,
		shuntState = 0,
		pantographFront = 0,
		pantographBack = 0;

	float
		voltageLoco = 0,
		amperageTE = 0,
		amperageUltimateTE = 0;

	// MV, MK
	bool
		isMVsActive = false,
		isMVsTEActive = false;

public:
	virtual ~LocoElectricBase() = 0;

	void readRAMValues(const RAM&, const ROM&) override;
};

