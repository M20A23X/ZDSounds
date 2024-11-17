#include "pch.h"
#include <fstream>

#include "exceptions\exception.hpp"

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
	if (this->ram != nullptr)
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
	if (!this->ram->GetConnectedToMemoryState() || this->ram->GetGamePauseState())
		return;

	if (!this->isInitialized) {
		this->isInitialized = true;

		try {
			this->ram->ReadSettingsIni();
		}
		catch (const Exception& exc) {
			throw Exception(L"Error during initialization - can't read virtual settings.ini!\n" + exc.getMessage());
		}

		try {
			this->ram->InitializeConsist();
		}
		catch (const Exception& exc) {
			throw Exception(L"Error during initialization - can't initialize consist!\n" + exc.getMessage());
		}
	}

	try {
		this->ram->ReadCommonValues();
	}
	catch (const Exception& exc) {
		throw Exception(L"Error reading RAM values!\n" + exc.getMessage());
	}
}
