#pragma once

#include <string>
#include <vector>
#include <tuple>
#include <queue>
#include <Windows.h>

#include "rapidjson\document.h"

#include "types\types.hpp"

using namespace std;


class ROM {
public:
	// Consist
	enum ConsistTypeEnum { PASSENGER, FREIGHT, RESERV };

	struct ConsistUnit {
		uint16_t length = 0;
		vector<uint16_t> axesArr;
	};

	struct Consist {
		ConsistTypeEnum type = ConsistTypeEnum::PASSENGER;
		wstring locoType;
		uint16_t length = 0;
		uint8_t
			sectionCount = 0,
			wagonCount = 0,
			axesCount = 0;
		ConsistUnit
			locoUnit,
			wagonUnit;
	};

	// Station borders from start_kilometers.dat
	struct Stations {
		vector<tuple<uint16_t, uint16_t>> stationsArr;
		bool isOnStation = false;
	};


	// Oncoming
	struct Oncoming : SavePrev {
		Consist consist;
		bool
			shouldReinit = false,
			shouldReset = false;
		float
			ordinateDelta = 0,
			ordinateDiff = 0,
			ordinate = 0,
			speed = 0;
		Value<uint16_t> track;
		queue<float> speeds;

		OncomingStatusEnum status = OncomingStatusEnum::COMING;

		void SavePrevious() override {
			this->track.previous = this->track.current;
		}
	};


public:
	const LPCWSTR ADDRESSES_DIR = L".\\zdsounds\\assets\\static\\addresses\\";

	rapidjson::Document addresses;
	rapidjson::Document addressesSpecific;


public:
	ROM();

	// Initialization
public:
	Stations ReadStations(const wstring&) const;
	Oncoming ReadOncomings(const wstring&, const wstring&) const;
	tuple<Consist, ConsistUnit, ConsistUnit> InitializeConsist(const wstring&) const;

	// Common
public:
	uintptr_t GetAddress(const rapidjson::Value&) const;
	uint32_t ReadOrdinateByTrack(const uint16_t&, const wstring&, const bool&) const;
private:
	ConsistUnit _ReadConsistUnit(const wstring&, uint8_t* = nullptr, const bool& = false) const;

	// Utils
public:
	void ReadAddressesFile(const wstring&, const boolean & = true);
};