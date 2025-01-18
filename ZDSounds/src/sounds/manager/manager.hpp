#pragma once

#include <string>
#include <map>

#include "data\ram.hpp"
#include "..\entity\entity.hpp"

using namespace std;


class SoundManager {
private:
	static const uint16_t DEFAULT_FREQUENCY = 44100;

	map<wstring, SoundEntity*> _sounds;

public:
	SoundManager();

	void Initialize(const RAM&);

private:
	void _ReadSoundEntities(const wstring&, const RAM&);
};
