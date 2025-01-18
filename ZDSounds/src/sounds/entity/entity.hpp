#pragma once

#include <string>
#include <vector>
#include <Windows.h>

#include "bass.h"
#include "bass_fx.h"

#include "types\types.hpp"
#include "data\ram.hpp"

using namespace std;


class SoundEntity {
private:
	static const float
		_CABIN_CENTER_X,			// x of the loco cabin center 
		_CAM_INIT_SEG_X_BOUND,		// segment's absolute bound of the camera initial position
		_CAM_INIT_SEG_MAPPED_X,		// mapped position (x) of the camera initial position under _CAMERA_INIT_SEG_X
		_CAM_INIT_SEG_MULT,			// mapped position (x) of the camera initial position under _CAMERA_INIT_SEG_X
		_CAM_INIT_SEG_SHIFT,		// mapped position (x) of the camera initial position under _CAMERA_INIT_SEG_X
		_CAM_LEFT_SIDE_SHIFT_0,		// mapped position (x) of the camera initial position under _CAMERA_INIT_SEG_X
		_CAM_LEFT_SIDE_SHIFT_1,		// mapped position (x) of the camera initial position under _CAMERA_INIT_SEG_X
		_CAM_Y_INIT,				// camera initial position (y

		_ENTITY_REMOVAL_X_INIT,		// initial distance to a sound entity (x); distance emulation to a sound entity

		_WALL_VOL_FADE_MULT,		// complementary balance coef (max pan)
		_WINDOW_CLOSED_VOL_MULT,	// fading through the wall
		_WINDOWS_CLOSED_VOL_MULT,	// fading through the wall

		_PAN_BALANCE_MULT;			// complementary balance coef (max pan)


private:
	static int8_t _Sign(const float&);

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

		SoundFile(const EnvEnum& env, wstring& file) : env{ env }, file{ file } {
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
		EnvEnum env = EnvEnum::CABIN;
		HSTREAM
			stream = 0,
			tempo = 0;
		AttrsFX attrs;
	};

private:
	const wstring _id;
	const wstring _soundId;
	const SoundPoint _soundPoint;
	vector<SoundFile> _soundFiles;
	uint8_t
		_channelCount = 0,
		_stateCount = 0,
		_timerCount = 0;
	ChannelFX* _channels = nullptr;
	bool* _states = nullptr;
	uint8_t* _timers = nullptr;

	const RAM::Camera* _camera = nullptr;
	Value<bool>* _windowsState = nullptr;
	const uint8_t _consistLength = 0;

public:
	SoundEntity(
		const RAM::Camera*, const uint8_t&, const wstring&, const wstring&, vector<SoundFile>&, const SoundPoint&,
		const uint8_t & = 1, const uint8_t & = 0, const uint8_t & = 0
	);

	~SoundEntity();

public:
	bool Check(const uint8_t&, const bool& = true);
	void Start(const uint8_t&, const wstring&, const bool& = false);
	void Pause(const uint8_t&);
	void Resume(const uint8_t&);
	void Free(const uint8_t&);
	void Update(const uint8_t&, const bool& = false);
};
