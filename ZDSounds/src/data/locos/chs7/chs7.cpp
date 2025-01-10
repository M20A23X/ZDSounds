#include "pch.h"

#include ".\chs7.hpp"


const unsigned MK_THRESHOLD = 16777216;


void CHS7::readRAMValues(const RAM& ram, const ROM& rom) {
	CHS7::SavePrevious();
	LocoElectricBase::readRAMValues(ram, rom);

	const HANDLE pHandle = ram.GetProcessHandle();


	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["edb"]), &this->amperageEDB, 4, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["epb"]), &this->isEPBActive, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["km"]), &this->kr21State, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["position-1"]), &this->positionSections[1], 1, NULL);


	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["pantograph"]["front"]), &this->pantographs[0], 2, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["pantograph"]["rear"]), &this->pantographs[1], 2, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["mvs"]), &this->areMVsActive, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["loco-voltage"]), &this->voltageLoco, 4, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["blinds"]), &this->areBlindsOpened, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["reverser"]), &this->reverserState, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["epb-sensor-pressure"]), &this->epbSensorPressure, 4, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["main-switch"]), &this->isMainSwitchActive.current, 1, NULL);

	// ÌÊ 1
	float mk1 = 0;
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["mks"]["mk-0"]), &mk1, 4, NULL);
	this->areMKsActive[0] = mk1 > 0;

	// ÌÊ 2
	uint8_t mk2mode = 0;	// ñîñòîÿíèÿ ÌÊ 1-2 
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addressesSpecific["mks"]["mk-1-mode"]), &mk2mode, 1, NULL);

	if (this->pressureLine.current <= 7.5 && this->pressureLine.current < this->pressureLine.previous)
		this->isMKsAutoStart = true;
	else if (this->pressureLine.current >= 9)
		this->isMKsAutoStart = false;

	this->areMKsActive[1] = this->isMainSwitchActive.current && this->voltageLoco > 0
		&& (mk2mode >= 1 && this->isMKsAutoStart || mk2mode == 2);

	ram.CloseProcessHandle(pHandle);
}

void CHS7::SavePrevious() {
	this->isEPBActive.previous = this->isEPBActive.current;
	this->areBlindsOpened.previous = this->areBlindsOpened.current;
}