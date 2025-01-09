#pragma once

#include <string>
#include "rapidjson\document.h"

#include "types\types.hpp"

#include "types\types.hpp"
#include "data\ram.hpp"


using namespace std;


const string ADDRESSES_DIR = ".\\..\\..\\..\\assets\\static\\addresses\\";

class RAM;
class ROM;
class LocoBase : SavePrev {
public:
	bool
		isMKsAutoStart = false,				// ����-����� �� 1-2
		isCoupling = false,					// ������
		isCombinedOpened = false,			// ���������������
		isWhistleActive = false,			// �������
		isHornActive = false,				// �����
		areMKsActive[2] = { false,false };	// �� 1-2

	Value<bool>
		windowsOpenState[2] = { false,false },		// ���� ���-����
		batteryChargeState[2] = { false,false },	// ������� ��� 1-2
		isVHPress,			// ��
		isVHSPress,			// ���
		isWipersActive,		// ����������������
		isVilignanceCheck,	// �������� ������������
		isHighlightsActive,	// ���������
		isEPVActive,		// ���
		isSlipping,			// ����������
		isMainSwitchActive;	// ��/��

	uint8_t			reversorState = 0;	// ����������
	Value<uint8_t>
		crane395State,					// 395
		crane254State;					// 254

	float
		amperageEPB = 0,			// ��� ���
		wipersDegree = 0,			// ���� �����������������
		brakeLinePressure = 0,		// ��
		balanceTankPressure = 0,	// ��
		auxBrakeTankPressure = 0;	// ����� ���.
	Value<float> pressureLine;		// �������� ���.


public:
	virtual ~LocoBase() = 0;
	virtual	void readRAMValues(const RAM&, const ROM&);
	void SavePrevious() override;
};

class LocoElectricBase : public LocoBase {
public:
	uint8_t
		positionSection0 = 0,		// ������� ����. (1)
		shunts = 0,					// �����
		pantographs[2] = { 0,0 };	// ��������� �� (0-63,��������/������)

	float
		voltageLoco = 0,		// ���������� ��
		amperageTE = 0,			// ��� ������ ���
		amperageUltimateTE = 0;	// ��������� ��� ���

	// MV, MK
	bool
		areMVsActive = false,	// ��
		isMVsTEActive = false;	// �� ���

public:
	virtual ~LocoElectricBase() = 0;
	void readRAMValues(const RAM&, const ROM&) override;
};

