#include "pch.h"

#define _USE_MATH_DEFINES
#include <cmath>

#include ".\entity.hpp"

using namespace std;


const uint32_t
DFF = 0,
DCF = BASS_STREAM_DECODE,
BSL = BASS_SAMPLE_LOOP;


const float
SoundEntity::_CABIN_CENTER_X = 0.5f,
SoundEntity::_CAM_INIT_SEG_X_BOUND = 1.35f,
SoundEntity::_CAM_INIT_SEG_MAPPED_X = -0.2f,
SoundEntity::_CAM_INIT_SEG_MULT = 1.78f,
SoundEntity::_CAM_INIT_SEG_SHIFT = 1.24f,
SoundEntity::_CAM_LEFT_SIDE_SHIFT_0 = 2.3f,
SoundEntity::_CAM_LEFT_SIDE_SHIFT_1 = 1.25f,
SoundEntity::_CAM_Y_INIT = 6.0f,

SoundEntity::_ENTITY_REMOVAL_X_INIT = 8.55f,

SoundEntity::_WALL_VOL_FADE_MULT = 0.5f,
SoundEntity::_WINDOW_CLOSED_VOL_MULT = 0.8f,
SoundEntity::_WINDOWS_CLOSED_VOL_MULT = 0.6f,

SoundEntity::_PAN_BALANCE_MULT = 0.7f;


SoundEntity::SoundEntity(
	const RAM::Camera* camera, const uint8_t& consistLength, const wstring& id, const wstring& soundId, vector<SoundEntity::SoundFile>& soundFiles,
	const SoundPoint& point, const uint8_t& channels, const uint8_t& states, const uint8_t& timers
)
	: _camera{ camera }, _consistLength{ consistLength }, _id{ id }, _soundId{ soundId }, _soundFiles{ soundFiles },
	_soundPoint{ point }, _channelCount{ channels }, _stateCount{ states }, _timerCount{ timers } {
	this->_channels = new ChannelFX[channels];
	this->_states = new bool[states];
	this->_timers = new uint8_t[timers];
}

SoundEntity::~SoundEntity() {
	if (this->_channels != nullptr)
		delete this->_channels;
	if (this->_states != nullptr)
		delete this->_states;
	if (this->_timers != nullptr)
		delete this->_timers;
}


int8_t SoundEntity::_Sign(const float& x) {
	return x < 0 ? -1 : (x > 0 ? 1 : 0);
}


void SoundEntity::Start(const uint8_t& idx, const wstring& fileName, const bool& flags) {
	if (idx >= this->_channelCount || fileName.empty() || this->_channels == nullptr)
		return;

	this->Free(idx);

	this->_channels[idx].stream = BASS_StreamCreateFile(false, fileName.c_str(), 0, 0, DCF);
	this->_channels[idx].tempo = BASS_FX_TempoCreate(this->_channels[idx].stream, BASS_FX_FREESOURCE);

	BASS_ChannelFlags(this->_channels[idx].tempo, flags, flags);
	this->Update(idx);

	BASS_ChannelPlay(this->_channels[idx].tempo, false);
}

void SoundEntity::Pause(const uint8_t& idx) {
	if (idx < this->_channelCount)
		BASS_ChannelPause(this->_channels[idx].tempo);
}

void SoundEntity::Resume(const uint8_t& idx) {
	if (idx < this->_channelCount)
		BASS_ChannelPlay(this->_channels[idx].tempo, false);
}

bool SoundEntity::Check(const uint8_t& idx, const bool& checkPlaying) {
	if (this->_channelCount != 0) {
		if (checkPlaying)	// At least one is playing
			return BASS_ChannelIsActive(this->_channels[idx].stream) != 0 || BASS_ChannelIsActive(this->_channels[idx].tempo) != 0;
		else				// Both are stoped
			return BASS_ChannelIsActive(this->_channels[idx].stream) == 0 && BASS_ChannelIsActive(this->_channels[idx].tempo) == 0;
	}
}

void SoundEntity::Free(const uint8_t& idx) {
	if (idx < this->_channelCount) {
		BASS_ChannelStop(this->_channels[idx].stream);
		BASS_StreamFree(this->_channels[idx].stream);
		BASS_ChannelStop(this->_channels[idx].tempo);
		BASS_StreamFree(this->_channels[idx].tempo);
	}
}

void SoundEntity::Update(const uint8_t& idx, const bool& check) {
	if (check && !this->Check(idx))
		return;

	const EnvEnum soundEnv = this->_channels[idx].env;

	float
		pan = 0.8f,		// pan coeff
		vol = 1.0f,		// vol coeff
		zoom = 0.0f;	// zoom distance

	// Camera fix
	Point cameraPoint{ this->_camera->point };
	float camAngleZ = this->_camera->angleZ;

	if (this->_camera->point.x <= -SoundEntity::_CAM_INIT_SEG_X_BOUND)
		cameraPoint.x = SoundEntity::_CAM_INIT_SEG_MULT * (this->_camera->point.x + SoundEntity::_CAM_INIT_SEG_SHIFT);
	else if (-SoundEntity::_CAM_INIT_SEG_X_BOUND < this->_camera->point.x && this->_camera->point.x <= SoundEntity::_CAM_INIT_SEG_X_BOUND)
		cameraPoint.x = SoundEntity::_CAM_INIT_SEG_MAPPED_X;
	else if (this->_camera->point.x > SoundEntity::_CAM_INIT_SEG_X_BOUND) {
		cameraPoint.x = this->_camera->point.x;
		cameraPoint.x = -1 / (cameraPoint.x - SoundEntity::_CAM_LEFT_SIDE_SHIFT_0) - SoundEntity::_CAM_LEFT_SIDE_SHIFT_1;
	}

	Point soundEntity{ this->_soundPoint.point };

	// Window-open-based volume
	if (soundEnv != this->_camera->env && soundEnv != EnvEnum::MACHINE) {
		if (!this->_windowsState[0].current && !this->_windowsState[1].current)
			vol = SoundEntity::_WINDOW_CLOSED_VOL_MULT;
		else if (!this->_windowsState[0].current || !this->_windowsState[1].current)
			vol = SoundEntity::_WINDOWS_CLOSED_VOL_MULT;
	}

	Point cameraVector;

	switch (this->_camera->env) {
	case EnvEnum::CABIN:
		if (soundEnv == EnvEnum::OUTSIDE || soundEnv == EnvEnum::COMMON) {
			// Window-open-based pan
			soundEntity.y = SoundEntity::_CAM_Y_INIT;
			soundEntity.x = SoundEntity::_ENTITY_REMOVAL_X_INIT + abs(this->_soundPoint.point.y);
			if (cameraPoint.x <= SoundEntity::_CABIN_CENTER_X)
				soundEntity.x = -SoundEntity::_ENTITY_REMOVAL_X_INIT - abs(this->_soundPoint.point.y);

			float
				panShiftSign = 0,
				panShiftCoeff = 0;
			if (this->_windowsState[0].current ^ this->_windowsState[1].current) {
				if (this->_windowsState[1].current) {
					soundEntity.x = -SoundEntity::_ENTITY_REMOVAL_X_INIT - abs(this->_soundPoint.point.y);
					panShiftSign = -1;
					panShiftCoeff = 1;
				}
				else if (this->_windowsState[0].current) {
					soundEntity.x = SoundEntity::_ENTITY_REMOVAL_X_INIT + abs(this->_soundPoint.point.y);
					panShiftSign = 1;
					panShiftCoeff = 2;
				}

				pan = (1 - SoundEntity::_PAN_BALANCE_MULT) + SoundEntity::_PAN_BALANCE_MULT * exp(-0.5 * pow(panShiftSign * cameraPoint.x - panShiftCoeff, 2));
			}
			else
				pan = 1 - exp(-2 * pow(cameraPoint.x - SoundEntity::_CABIN_CENTER_X, 2));
		}
		else if (soundEnv == EnvEnum::MACHINE)
			vol = SoundEntity::_WALL_VOL_FADE_MULT;
		break;
	case EnvEnum::OUTSIDE:
		zoom = this->_camera->zoom;
		camAngleZ = camAngleZ - 15 * M_PI / 180;
		cameraPoint.x = -zoom * sin(camAngleZ);
		cameraPoint.y = -zoom * cos(camAngleZ);
		break;
	case EnvEnum::COMMON:
		zoom = SoundEntity::_Sign(cameraVector.x) * this->_camera->zoom + this->_consistLength;
		break;
	}

	cameraVector.x = sin(camAngleZ);
	cameraVector.y = cos(camAngleZ);

	Point soundVector{ cameraPoint.x - soundEntity.x , cameraPoint.y - soundEntity.y, 0 };

	float soundVectorLen = sqrt(pow(soundVector.x, 2) + pow(soundVector.y, 2));

	// Normalization
	soundVector.x = soundVector.x / soundVectorLen;
	soundVector.y = soundVector.y / soundVectorLen;

	// Pan
	float vectorMult = (cameraVector.x - soundVector.x) * -soundVector.y - (cameraVector.y - soundVector.y) * -soundVector.x;
	this->_channels[idx].attrs.pan = pan * vectorMult;

	// Volume
	float volumeArg = pow(soundVectorLen + zoom, 2);
	float volume = vol * this->_channels[idx].attrs.volume *
		(0.01 * exp(-1E-7 * volumeArg) + 0.99 * exp(-1E-5 * volumeArg)); // TODO normalization-centering per sound

	if (this->_channels[idx].attrs.volume < 0)
		this->_channels[idx].attrs.volume = 0;

	BASS_ChannelSetAttribute(this->_channels[idx].tempo, BASS_ATTRIB_VOL, this->_channels[idx].attrs.volume);
	BASS_ChannelSetAttribute(this->_channels[idx].tempo, BASS_ATTRIB_TEMPO, this->_channels[idx].attrs.tempo);
	BASS_ChannelSetAttribute(this->_channels[idx].tempo, BASS_ATTRIB_TEMPO_PITCH, this->_channels[idx].attrs.pitch);
	BASS_ChannelSetAttribute(this->_channels[idx].tempo, BASS_ATTRIB_PAN, this->_channels[idx].attrs.pan);
}
