#pragma once

#include <string>
#include <vector>
#include <Windows.h>

#include "types\types.hpp"

using namespace std;


class SoundEntity {
public:
	struct SoundPoint {
		Point point;
		float masterVolume = 0;

		SoundPoint(const Point& point, const float& volume)
			: point{ point }, masterVolume{ volume }{
		}
	};

	struct SoundFile {
		EnvEnum env = EnvEnum::CABIN;
		wstring file;

		SoundFile(const EnvEnum& env, wstring& file) :env{ env }, file{ file } {
		}
	};

	struct AttrsFX {
		double
			volume = 1,
			tempo = 0,
			pitch = 0,
			pan = 0;
	};

	struct ChannelFX {
		uint16_t
			default = 0,
			tempo = 0;
		AttrsFX attrs;
	};

public:
	const wstring id;
	const wstring soundId;
	const SoundPoint point;
	vector<SoundFile> soundFiles;
	const ChannelFX* channels = nullptr;
	const bool* states = nullptr;
	const uint8_t* timers = nullptr;

public:
	SoundEntity(
		const wstring& id, const wstring& soundId, vector<SoundFile>& soundFiles, const SoundPoint& point,
		const uint8_t& channels, const uint8_t& states, const uint8_t& timers
	);

	~SoundEntity();

	bool check(const uint8_t& idx, const bool& checkPlaying = true);
	void restart(const uint8_t& idx, const wstring& fileName, const bool& flags = 0);
	void pause(const uint8_t& idx);
	void resume(const uint8_t& idx);
	void free(const uint8_t& idx);
	void updateAttrs(const uint8_t& idx, const bool& check = false);
	void update();
};
