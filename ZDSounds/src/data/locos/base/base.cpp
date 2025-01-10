#include "pch.h"

#include ".\base.hpp"


LocoBase::~LocoBase() {}

void LocoBase::readRAMValues(const RAM& ram, const ROM& rom) {
	LocoBase::SavePrevious();
	
	const HANDLE pHandle = ram.GetProcessHandle();

	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["aux-brake"]), &this->auxBrakeTankPressure, 4, NULL);

	uintptr_t addrBalancetank = ram.ReadPointer(rom.GetAddress(rom.addresses["loco"]["balance-tank"])) + 32;
	ReadProcessMemory(pHandle, (LPCVOID)addrBalancetank, &this->balanceTankPressure, 4, NULL);

	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["battery-charge-0"]), &this->batteryChargeState[0].current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["battery-charge-1"]), &this->batteryChargeState[1].current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["brake-line"]), &this->brakeLinePressure, 4, NULL);

	uintptr_t addrCombined = ram.ReadPointer(rom.GetAddress(rom.addresses["loco"]["combined"])) + 48;
	ReadProcessMemory(pHandle, (LPCVOID)addrCombined, &this->isCombinedOpened, 1, NULL);

	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["couple"]), &this->isCoupling, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["crane-254"]), &this->crane254State.current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["crane-395"]), &this->crane395State.current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["epb"]), &this->amperageEPB, 4, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["epv"]), &this->isEPVActive.current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["highlights"]), &this->isHighlightsActive.current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["horn"]), &this->isHornActive, 1, NULL);

	uintptr_t addrPressureLine = ram.ReadPointer(rom.GetAddress(rom.addresses["loco"]["pressure-line"])) + 240;
	ReadProcessMemory(pHandle, (LPCVOID)addrPressureLine, &this->pressureLine.current, 4, NULL);

	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["slipping"]), &this->isSlipping.current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["vh"]), &this->isVHPress.current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["vhs"]), &this->isVHSPress.current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["vilignance-check"]), &this->isVilignanceCheck.current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["whistle"]), &this->isWhistleActive, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["wipers"]), &this->isWipersActive.current, 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["wipers-degree"]), &this->wipersDegree, 4, NULL);

	ram.CloseProcessHandle(pHandle);
};

void LocoBase::SavePrevious() {
	this->windowsOpenState[0].previous = this->windowsOpenState[0].current;
	this->windowsOpenState[1].previous = this->windowsOpenState[1].current;
	this->batteryChargeState[0].previous = this->batteryChargeState[0].current;
	this->batteryChargeState[1].previous = this->batteryChargeState[1].current;
	this->isVHPress.previous = this->isVHPress.current;
	this->isVHSPress.previous = this->isVHSPress.current;
	this->isWipersActive.previous = this->isWipersActive.current;
	this->isVilignanceCheck.previous = this->isVilignanceCheck.current;
	this->isHighlightsActive.previous = this->isHighlightsActive.current;
	this->isEPVActive.previous = this->isEPVActive.current;
	this->isSlipping.previous = this->isSlipping.current;
	this->isMainSwitchActive.previous = this->isMainSwitchActive.current;
	this->crane395State.previous = this->crane395State.current;
	this->crane254State.previous = this->crane254State.current;
	this->pressureLine.previous = this->pressureLine.current;
}


LocoElectricBase::~LocoElectricBase() {}

void LocoElectricBase::readRAMValues(const RAM& ram, const ROM& rom) {
	LocoElectricBase::SavePrevious();
	LocoBase::readRAMValues(ram, rom);

	const HANDLE pHandle = ram.GetProcessHandle();

	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["position-0"]), &this->positionSections[0], 1, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco-electric"]["te"]), &this->amperageTE, 4, NULL);
	ReadProcessMemory(pHandle, (LPCVOID)rom.GetAddress(rom.addresses["loco"]["shunts"]), &this->shunts, 1, NULL);

	ram.CloseProcessHandle(pHandle);
};