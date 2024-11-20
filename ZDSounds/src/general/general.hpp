#pragma once

#include "data\ram.hpp"

class General {
private:
	RAM* _ram;
	bool _isInstalledCorrectly = false;
	bool _isInitialized = false;

public:
	// Constructor-Destructor
	General();
	~General();

	// Getters
	RAM* GetRAM() const;
	bool GetInstallationState() const;

	// Common
	void TickMainTimer();
};