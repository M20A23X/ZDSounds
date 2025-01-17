#include "pch.h"

#include ".\entity.hpp"

using namespace std;


SoundEntity::SoundEntity(
	const wstring& id, const wstring& soundId, vector<SoundEntity::SoundFile>& soundFiles, const SoundPoint& point, const uint8_t& channels = 1,
	const uint8_t& states = 0, const uint8_t& timers = 0
) : id{ id }, soundId{ soundId }, soundFiles{ soundFiles }, point{ point } {
	this->channels = new ChannelFX[channels];
	this->states = new bool[states];
	this->timers = new uint8_t[timers];
}

SoundEntity::~SoundEntity() {
	if (this->channels != nullptr)
		delete this->channels;
	if (this->states != nullptr)
		delete this->states;
	if (this->timers != nullptr)
		delete this->timers;
}
