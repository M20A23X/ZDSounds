#pragma once

#include "data\ram.hpp"
#include "sounds\sound.hpp"


class General {
private:
	RAM* _ram;
	SoundManager* _soundManager;

	bool _isInstalledCorrectly = false;
	bool _isInitialized = false;

public:
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