#include "pch.h"
#include <fstream>

#include "exceptions\exception.hpp"

#include ".\general.hpp"


General::General() {
	this->_ram = new RAM();

	// Installation check
	ifstream exeFile(this->_ram->GetExeName());
	this->_isInstalledCorrectly = exeFile.good();
}

General::~General() {
	if (this->_ram != nullptr)
		delete this->_ram;
}


// Getters //////////

// GetRAM
RAM* General::GetRAM() const {
	return this->_ram;
}

// CheckInstallation
bool General::GetInstallationState() const {
	return this->_isInstalledCorrectly;
}

bool General::GetInitializedState() const {
	return this->_isInitialized;
}

// Common //////////

// TickMainTimer
void General::TickMainTimer() {
	this->_ram->HandleZDSWindow();

	if (!this->_ram->GetConnectedToMemoryState() || this->_ram->GetGamePauseState())
		return;

	if (!this->_isInitialized) {
		this->_isInitialized = true;
		try {
			this->_ram->Initialize();
		}
		catch (const Exception& exc) {
			throw Exception(L"Error during initialization! " + exc.getMessage());
		}
	}

	try {
		this->_ram->ReadGameValues();
	}
	catch (const Exception& exc) {
		throw Exception(L"Error reading RAM values! " + exc.getMessage());
	}
}
