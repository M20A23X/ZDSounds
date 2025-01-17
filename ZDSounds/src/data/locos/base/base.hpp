#pragma once

#include <string>
#include "rapidjson\document.h"

#include "types\types.hpp"

#include "types\types.hpp"
#include "data\ram.hpp"

using namespace std;


class RAM;
class ROM;
class LocoBase : SavePrev {
public:
	bool
		isMKsAutoStart = false,				// авто-старт МК 1-2
		isCoupling = false,					// сцепка
		isCombinedOpened = false,			// комбинированный
		isWhistleActive = false,			// свисток
		isHornActive = false,				// тифон
		areMKsActive[2] = { false,false };	// МК 1-2

	Value<bool>
		windowsOpenState[2] = { false,false },		// окна лев-прав
		batteryChargeState[2] = { false,false },	// зарядка АКБ 1-2
		isVHPress,			// РБ
		isVHSPress,			// РБС
		isWipersActive,		// стеклоочестители
		isVilignanceCheck,	// проверка бдительности
		isHighlightsActive,	// прожектор
		isEPVActive,		// ЭПК
		isSlipping,			// боксование
		isMainSwitchActive;	// БВ/ГВ

	int8_t	reverserState = 0;	// реверсивка
	Value<uint8_t>
		crane395State,			// 395
		crane254State;			// 254

	float
		amperageEPB = 0,			// ток ЭПТ
		wipersDegree = 0,			// угол стеклоочестителей
		brakeLinePressure = 0,		// ТМ
		balanceTankPressure = 0,	// УР
		auxBrakeTankPressure = 0;	// вспом цил.
	Value<float> pressureLine;		// напорная маг.


public:
	virtual ~LocoBase() = 0;
	virtual	void readRAMValues(const RAM&, const ROM&);
	void SavePrevious() override;
};

class LocoElectricBase : public LocoBase {
public:
	uint8_t
		shunts = 0,						// шунты
		positionSections[2] = { 0,0 },	// степень секций (1 или 1-2)
		pantographs[2] = { 0,0 };		// состояние ТП (0-63,передний/задний)

	float
		voltageLoco = 0,		// напряжение КС
		amperageTE = 0,			// ток якорей ТЭД
		amperageUltimateTE = 0;	// граничный ток ТЭД

	// MV, MK
	bool
		areMVsActive = false,	// МВ
		isMVsTEActive = false;	// МВ ТЭД

public:
	virtual ~LocoElectricBase() = 0;
	void readRAMValues(const RAM&, const ROM&) override;
};

