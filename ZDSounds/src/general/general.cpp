#include "pch.h"
#include <fstream>

#include ".\general.hpp"


/// Public ////////////////////

// Constructor-Destructor //////////
General::General() {
	this->ram = new RAM();

	// Installation check
	ifstream exeFile(this->ram->GetExeName());
	this->isInstalledCorrectly = exeFile.good();
}

General::~General() {
	delete this->ram;
}


// Getters //////////

// GetRAM
RAM* General::GetRAM() const {
	return this->ram;
}

// CheckInstallation
bool General::GetInstallationState() const {
	return this->isInstalledCorrectly;
}

// Common //////////

// TickMainTimer
void General::TickMainTimer() {
	this->ram->HandleZDSWindow();
	if (!this->ram->CheckConnectedToMemory() || this->ram->CheckOnPause()) {
		return;
	}

	if (!this->isInitialized) {
		this->isInitialized = true;
		this->ram->ReadSettingsIni();
	}

	this->ram->ReadCommonValues();
}
