#pragma once

#include <fstream>
#include <string>

#include "types\types.hpp"

#include "..\base\base.hpp"

using namespace std;


class CHS7 : public LocoElectricBase {
public:
	Value<bool>
		isEPBActive,									// ��������� ���
		areBlindsOpened;								// ������
	KR21StateEnum kr21State = KR21StateEnum::NEUTRAL;	// ����������

	float
		epbSensorPressure = 0,	// ������ ���
		amperageEDB = 0;		// ��� ���

public:
	void readRAMValues(const RAM&, const ROM&) override;
	void SavePrevious() override;

public: 

};