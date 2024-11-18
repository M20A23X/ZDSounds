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

// Common //////////

// TickMainTimer
void General::TickMainTimer() {
	this->_ram->HandleZDSWindow();
	if (!this->_ram->GetConnectedToMemoryState() || this->_ram->GetGamePauseState())
		return;

	if (!this->_isInitialized) {
		this->_isInitialized = true;

		try {
			this->_ram->ReadSettingsIni();
		}
		catch (const Exception& exc) {
			throw Exception(L"Error during initialization - can't read virtual settings.ini!\n" + exc.getMessage());
		}

		try {
			this->_ram->InitializeConsist();
		}
		catch (const Exception& exc) {
			throw Exception(L"Error during initialization - can't initialize consist!\n" + exc.getMessage());
		}
	}

	try {
		this->_ram->ReadCommonValues();
	}
	catch (const Exception& exc) {
		throw Exception(L"Error reading RAM values!\n" + exc.getMessage());
	}
}
