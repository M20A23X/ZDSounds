#include "pch.h"

#include ".\chs7.hpp"


const unsigned MK_THRESHOLD = 16777216;


void CHS7::readRAMValues(const RAM& ram, const ROM& rom) {
	CHS7::SavePrevious();
	LocoElectricBase::readRAMValues(ram, rom);

	SIZE_T* temp = nullptr;
	const HANDLE pHandle = ram.GetProcessHandle();


	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["edb"]), &this->amperageEDB, 4, temp);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["epb"]), &this->isEPBActive, 1, temp);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["km"]), &this->kr21State, 1, temp);


	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["pantograph"]["front"]), &this->pantographs[0], 2, temp);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["pantograph"]["rear"]), &this->pantographs[1], 2, temp);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["mvs"]), &this->areMVsActive, 1, temp);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["locoVoltage"]), &this->voltageLoco, 4, temp);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["blinds"]), &this->areBlindsOpened, 1, temp);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["reversor"]), &this->reversorState, 1, temp);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["position1"]), &this->positionSection1, 1, temp);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["epbSensorPressure"]), &this->epbSensorPressure, 4, temp);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["mainSwitch"]), &this->isMainSwitchActive.current, 1, temp);

	// ÌÊ 1
	float mk0 = 0.0f;
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["mks"]["mk0"]), &mk0, 4, temp);
	this->areMKsActive[0] = mk0 > 0;

	// ÌÊ 2
	uint8_t mk1Mode = 0;	// ñîñòîÿíèÿ ÌÊ 1-2 
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["mks"]["mk1Mode"]), &mk1Mode, 1, temp);

	if (this->pressureLine.current <= 7.5 && this->pressureLine.current < this->pressureLine.previous)
		this->isMKsAutoStart = true;
	else if (this->pressureLine.current >= 9)
		this->isMKsAutoStart = false;

	this->areMKsActive[1] = this->isMainSwitchActive.current && this->voltageLoco > 0
		&& (mk1Mode >= 1 && this->isMKsAutoStart || mk1Mode == 2);

	ram.CloseProcessHandle(pHandle);
}

void CHS7::SavePrevious() {
	this->isEPBActive.previous = this->isEPBActive.current;
	this->areBlindsOpened.previous = this->areBlindsOpened.current;
}