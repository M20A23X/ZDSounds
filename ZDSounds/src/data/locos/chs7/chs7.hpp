#pragma once

#include <fstream>
#include <string>

#include "types\types.hpp"

#include "..\base\base.hpp"

using namespace std;


class CHS7 : public LocoElectricBase {
public:
	Value<bool>
		isEPBActive,									// состояние ЭПТ
		areBlindsOpened;								// жалюзи
	KR21StateEnum kr21State = KR21StateEnum::NEUTRAL;	// контроллер

	float
		epbSensorPressure = 0,	// датчик ЭПТ
		amperageEDB = 0;		// ток ЭДТ

	void readRAMValues(const RAM&, const ROM&) override;
	void SavePrevious() override;
};