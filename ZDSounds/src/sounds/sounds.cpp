#include "pch.h"
#include <fstream>

#include "rapidjson\document.h"

#include "bass.h"
#include "bass_fx.h"

#include "exceptions\exception.hpp"

#include ".\sound.hpp"



SoundManager::SoundManager() {
}

void SoundManager::Initialize(const RAM& ram) {
	try {
		const HWND wHandle = ram.GetWindowHandle();
		const bool isInitialized = BASS_Init(-1, SoundManager::DEFAULT_FREQUENCY, 0, wHandle, NULL);
		if (!isInitialized)
			throw Exception(L"BASS_Init");
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't initialize BASS! " + exc.getMessage());
	}

	try {
		this->_ReadSoundEntities(ram.GetRAMValues().settingsIni->locoType, *ram.GetROM());
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't read sound entities! " + exc.getMessage());
	}

}

void SoundManager::_ReadSoundEntities(const wstring& entity, ROM& rom) {
	const wstring jsonFile = L"zdsounds\\consist\\" + entity + L"\\entity\\entity.json";

	rapidjson::Document json;
	rom.ReadJSON(jsonFile, json);

	if (!json.IsArray())
		throw Exception(L"Can't read sound entities for: " + entity);

	for (rapidjson::Value::ConstValueIterator itr = json.Begin(); itr != json.End(); ++itr) {
		const wstring id = CharsToWStr((*itr)["id"].GetString());
		this->_sounds[id] = &SoundEntity(
			id,
			SoundManager::_SoundPoint(
				Point((*itr)["x"].GetDouble(), (*itr)["z"].GetDouble(), (*itr)["z"].GetDouble()),
				(EnvEnum)(*itr)["env"].GetInt(),
				(*itr)["vol"].GetDouble()
			),
			(*itr).HasMember("channels") ? (*itr)["channels"].GetInt() : 1,
			(*itr).HasMember("states") ? (*itr)["states"].GetInt() : 0,
			(*itr).HasMember("timers") ? (*itr)["timers"].GetInt() : 0
		);
	}
}

