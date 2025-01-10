#pragma once

#include <string>
#include <map>

#include "data\ram.hpp"
#include "types\types.hpp"

using namespace std;


class SoundManager {
private:
	struct _SoundPoint {
		Point point;
		EnvEnum env = EnvEnum::CABIN;
		float masterVolume = 0;

		_SoundPoint(const Point& point, const EnvEnum& env, const float& volume)
			: point{ point }, env{ env }, masterVolume{ volume }{
		}
	};

public:
	struct AttrsFX {
		double
			volume = 0,
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

	struct SoundEntity {
	public:
		const wstring id;
		const _SoundPoint point;
		const ChannelFX* channels = nullptr;
		const bool* states = nullptr;
		const uint8_t* timers = nullptr;

	public:
		SoundEntity(const wstring& id, const _SoundPoint& point, const uint8_t& channels = 1, const uint8_t& states = 0, const uint8_t& timers = 0)
			: id(id), point{ point } {
			this->channels = new ChannelFX[channels];
			this->states = new bool[states];
			this->timers = new uint8_t[timers];
		}

		~SoundEntity() {
			if (this->channels != nullptr)
				delete this->channels;
			if (this->states != nullptr)
				delete this->states;
			if (this->timers != nullptr)
				delete this->timers;
		}

		bool check(const uint8_t& idx, const bool& checkPlaying = true);
		void restart(const uint8_t& idx, const wstring& fileName, const bool& flags = 0);
		void pause(const uint8_t& idx);
		void resume(const uint8_t& idx);
		void free(const uint8_t& idx);
		void updateAttrs(const uint8_t& idx, const bool& check = false);
		void update();
	};

private:
	static const uint16_t DEFAULT_FREQUENCY = 44100;

	map<wstring, SoundEntity*> _sounds;

public:
	SoundManager();

	void Initialize(const RAM&);

private:
	void _ReadSoundEntities(const wstring&, ROM&);
};
