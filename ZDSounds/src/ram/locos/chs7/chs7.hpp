#pragma once

#include <fstream>
#include <string>

#include "..\..\..\types\types.hpp"
#include "..\base\base.hpp"

using namespace std;

struct CHS7 : public LocoElectricBase {
public:
	Value<bool>
		isEPBActive,
		isBlindsOpened;
	KR21StateEnum	kr21State = KR21StateEnum::NEUTRAL;
	uint8_t			positionSection1 = 0;
	float			epbSensorPressure = 0.0f;
	bool			mksState[2] = { false,false };

	void readRAMValues();
};