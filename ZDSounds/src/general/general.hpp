#pragma once

#include "..\ran\ram.hpp"

class General {
	// Vars //////////
private:
	RAM* ram;
	bool isInstalledCorrectly = false;
	bool isInitialized= false;

	// Methods //////////
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