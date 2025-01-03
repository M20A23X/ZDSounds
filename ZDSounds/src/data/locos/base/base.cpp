#include "pch.h"

#include ".\base.hpp"


LocoBase::~LocoBase() {}

void LocoBase::readRAMValues(const RAM& ram, const ROM& rom) {
	SIZE_T* temp = nullptr;
	const HANDLE pHandle = ram.GetProcessHandle();

	uintptr_t addrCombined = ram.ReadPointer(rom.GetAddress((*rom.GetAddressesCommon())["loco"]["combined"])) + 48;
	ReadProcessMemory(pHandle, (LPCVOID)addrCombined, &this->isCombinedOpened, 1, temp);

	ram.CloseProcessHandle(pHandle);
};


LocoElectricBase::~LocoElectricBase() {}

void LocoElectricBase::readRAMValues(const RAM& ram, const ROM& rom) {
	LocoBase::readRAMValues(ram, rom);

	SIZE_T* temp = nullptr;
	const HANDLE pHandle = ram.GetProcessHandle();

	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress((*rom.GetAddressesSpecific())["locoVoltage"]), &this->voltageLoco, 4, temp);

	ram.CloseProcessHandle(pHandle);
};