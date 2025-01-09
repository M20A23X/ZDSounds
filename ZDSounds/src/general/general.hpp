#pragma once

#include "data\ram.hpp"

class General {
private:
	RAM* _ram;
	bool _isInstalledCorrectly = false;
	bool _isInitialized = false;

public:
	static const uint16_t DEFAULT_FREQUENCY = 44100;

	// Constructor-Destructor
	General();
	~General();

	// Getters
	RAM* GetRAM() const;
	bool GetInstallationState() const;
	bool GetInitializedState() const;

	// Common
	void TickMainTimer();
};