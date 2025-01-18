#include "pch.h"
#include <fstream>

#include "exceptions\exception.hpp"

#include ".\general.hpp"


General::General() {
	this->_ram = new RAM();
	this->_soundManager = new SoundManager();

	// Installation Check
	ifstream exeFile(this->_ram->GetExeName());
	this->_isInstalledCorrectly = exeFile.good();
}

General::~General() {
	if (this->_ram != nullptr)
		delete this->_ram;
	if (this->_soundManager != nullptr)
		delete this->_soundManager;
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
			throw Exception(L"Can't initialize RAM module! " + exc.getMessage());
		}
		try {
			this->_soundManager->Initialize(*this->_ram);
		}
		catch (const Exception& exc) {
			throw Exception(L"Can't sound manager! " + exc.getMessage());
		}
	}

	try {
		this->_ram->ReadGameValues();
	}
	catch (const Exception& exc) {
		throw Exception(L"Error reading RAM values! " + exc.getMessage());
	}
}
