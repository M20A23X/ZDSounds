#include "pch.h"

#include "rapidjson\document.h"

#include "bass.h"
#include "bass_fx.h"

#include "exceptions\exception.hpp"

#include ".\manager.hpp"



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

	const wstring locoType = ram.GetRAMValues().settingsIni->locoType;
	try {
		this->_ReadSoundEntities(locoType, *ram.GetROM());
	}
	catch (const Exception& exc) {
		throw Exception(L"Can't read sound entities for " + locoType + L"! " + exc.getMessage());
	}
}

void SoundManager::_ReadSoundEntities(const wstring& entity, ROM& rom) {
	const wstring jsonFile = L".\\zdsounds\\entities\\stock\\locos\\" + entity + L"\\entities.json";

	rapidjson::Document json;
	rom.ReadJSON(jsonFile, json);

	if (!json.IsArray())
		throw Exception(L"Can't read sound entities for: " + entity);

	rapidjson::Value::ConstValueIterator entityItr = json.Begin();
	while (entityItr != json.End()) {
		const wstring id = CharsToWStr((*entityItr)["id"].GetString()).c_str();
		const wstring soundId = entityItr->HasMember("sound-id")
			? CharsToWStr((*entityItr)["sound-id"].GetString()).c_str()
			: id;

		rapidjson::Document soundEntityJson;
		wstring soundEntityFile = L".\\zdsounds\\entities\\stock\\locos\\" + entity + L"\\" + soundId + L"\\_entity.json";
		if (!rom.ReadJSON(soundEntityFile, soundEntityJson, false))
			soundEntityFile = L".\\zdsounds\\entities\\stock\\locos\\_common\\" + soundId + L"\\_entity.json";
		if (!rom.ReadJSON(soundEntityFile, soundEntityJson))
			throw Exception(L"Can't find sound entity: " + soundId);

		uint8_t
			channels = 1,
			states = 0,
			timers = 0;
		if (soundEntityJson.HasMember("channels"))
			channels = soundEntityJson["channels"].GetInt();
		if (soundEntityJson.HasMember("states"))
			states = soundEntityJson["states"].GetInt();
		if (soundEntityJson.HasMember("timers"))
			timers = soundEntityJson["timers"].GetInt();

		vector<SoundEntity::SoundFile> files;
		rapidjson::Value::ConstValueIterator fileItr = soundEntityJson["files"].Begin();
		while (fileItr != soundEntityJson["files"].End()) {
			files.push_back(SoundEntity::SoundFile(
				(EnvEnum)(*fileItr)["env"].GetInt(),
				CharsToWStr((*fileItr)["file"].GetString())
			));
			++fileItr;
		}


		float vol = 1;
		if (entityItr->HasMember("vol"))
			vol = (*entityItr)["vol"].GetDouble();

		this->_sounds[id] = &SoundEntity(
			id,
			soundId,
			files,
			SoundEntity::SoundPoint(
				Point(
					(*entityItr)["x"].GetDouble(),
					(*entityItr)["z"].GetDouble(),
					(*entityItr)["z"].GetDouble()
				),
				vol
			),
			channels,
			states,
			timers
		);

		++entityItr;
	}
}

