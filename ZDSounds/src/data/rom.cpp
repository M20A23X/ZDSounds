#include "pch.h"
#include <fstream>

#include "exceptions\exception.hpp"

#include ".\rom.hpp"


enum FileValueEnum {
	LOCO_SECITONS_COUNT = 0,
	STATION_KILOMETER_START = 1,
	STATION_KILOMETER_END = 2,
	ONCOMING_SPEED = 3,
	TRACK_LIST_TRACK = 7,
	TRACK_LIST_ORDINATE = 10
};


ROM::ROM() {
	this->ReadAddressesFile(wstring(this->ADDRESSES_DIR) + L"common.json");
}


// Initialization //////////

tuple<ROM::Consist, ROM::ConsistUnit, ROM::ConsistUnit> ROM::InitializeConsist(const wstring& locoType) const {
	ROM::Consist consist;
	ROM::ConsistUnit passWagonUnit;
	ROM::ConsistUnit freightWagonUnit;

	consist.locoType = locoType;

	consist.locoUnit = _ReadConsistUnit(consist.locoType, &consist.sectionCount, true);
	passWagonUnit = _ReadConsistUnit(L"passenger");
	freightWagonUnit = _ReadConsistUnit(L"freight");

	uint16_t wagonAxesCount = 0;
	uint16_t wagonLength = 0;
	if (consist.type == ConsistTypeEnum::PASSENGER) {
		wagonLength = passWagonUnit.length;
		wagonAxesCount = static_cast<uint16_t>(passWagonUnit.axesArr.size());
	}
	else if (consist.type = ConsistTypeEnum::FREIGHT) {
		wagonLength = freightWagonUnit.length;
		wagonAxesCount = static_cast<uint16_t>(passWagonUnit.axesArr.size());
	}

	consist.axesCount = static_cast<uint16_t>(consist.locoUnit.axesArr.size()) + consist.wagonCount * wagonAxesCount;
	consist.length = wagonLength * consist.wagonCount + consist.locoUnit.length;

	return make_tuple(consist, passWagonUnit, freightWagonUnit);
}

ROM::Stations ROM::ReadStations(const wstring& routeName) const {
	const wstring file = L".\\routes\\" + routeName + L"\\start_kilometers.dat";

	wifstream fileStream(file, ifstream::binary);
	if (!fileStream.good())
		throw Exception(L"Error reading file: " + file);

	ROM::Stations stations;
	wstring line;

	while (!fileStream.eof()) {
		getline(fileStream, line);
		if (line == L"\n")
			continue;

		const vector<wstring> tokens = SplitStr(line, L" ");
		try {
			if (tokens.size() >= 3) {
				tuple<uint16_t, uint16_t> entry(stoi(tokens[STATION_KILOMETER_START]), stoi(tokens[STATION_KILOMETER_END]));
				stations.stationsArr.push_back(entry);
			}
		}
		catch (...) {
			fileStream.close();
			throw Exception(L"Invalid entry values: '" + tokens[STATION_KILOMETER_START] + L"', '" + tokens[STATION_KILOMETER_END] + L"'");
		}
	}

	fileStream.close();
	return stations;
}


// Common //////////

uintptr_t ROM::GetAddress(const rapidjson::Value& value) const {
	istringstream converter(value.GetString());
	uintptr_t address;
	converter >> std::hex >> address;
	return address;
}


uint32_t ROM::ReadOrdinateByTrack(const uint16_t& track, const wstring& routeName, const bool& isBackward) const {
	wstring line;
	wstring ordinate;

	const wstring file = L".\\routes\\" + routeName + L"\\route" + to_wstring(isBackward + 1) + L".trk";

	wifstream fileStream(file);
	if (!fileStream.good())
		throw Exception(L"Error reading file: " + file);

	while (!fileStream.eof()) {
		getline(fileStream, line);
		const vector<wstring> tokens = SplitStr(line, L",");

		if (stoi(tokens[TRACK_LIST_TRACK]) == track) {
			wstring ordinateStr = tokens[TRACK_LIST_ORDINATE];
			ordinateStr.pop_back();
			try {
				return stoi(ordinateStr);
			}
			catch (...) {
				throw Exception(L"Invalid sections count: '" + tokens[LOCO_SECITONS_COUNT] + L"'");
			}
			finally {
				fileStream.close();
			}
		}
	}

	throw Exception(L"Error reading ordinate by track - " + to_wstring(track) + L"track not found!");
}

ROM::ConsistUnit ROM::_ReadConsistUnit(const wstring& dir, uint8_t* sectionCountPtr, const bool& isLoco) const {
	ConsistUnit unit;
	uint8_t idxShift = uint8_t(isLoco);

	wstring file = L".\\zdsounds\\entities\\stock\\" + wstring(isLoco ? L"locos\\" : L"wagons\\") + dir + L"\\axes.dat";
	wstring line;

	wifstream fileStream(file);
	if (!fileStream.good())
		throw Exception(L"Error opening file '" + file + L"'!");

	getline(fileStream, line);
	fileStream.close();

	const vector<wstring> tokens = SplitStr(line, L" ");

	if (tokens.size() == 0)
		throw Exception(L"Error initializing consist unit - no data!");

	try {
		if (isLoco)
			*sectionCountPtr = stoi(tokens[LOCO_SECITONS_COUNT]);
	}
	catch (...) {
		throw Exception(L"Invalid sections count: '" + tokens[LOCO_SECITONS_COUNT] + L"'");
	}

	for (uint8_t i = idxShift; i < tokens.size() - 1; i++) {
		try {
			unit.axesArr.push_back(stoi(tokens[i]));
		}
		catch (...) {
			throw Exception(L"Invalid axis distance: '" + tokens[i] + L"'");
		}
		unit.length = unit.length + unit.axesArr[i - idxShift];
		unit.length = unit.length + unit.axesArr[unit.axesArr.size() - 1];
	}

	return unit;
}

ROM::Oncoming ROM::ReadOncomings(const wstring& routeName, const wstring& sceneryName) const {
	const wstring file = L".\\routes\\" + routeName + L"\\scenaries\\" + sceneryName;

	wifstream fileStream(file);
	if (!fileStream.good())
		throw Exception(L"Error opening file '" + file + L"'!");

	ROM::Oncoming oncoming;
	wstring line;

	while (!fileStream.eof() && line != L"[oncoming traffic]")
		getline(fileStream, line);

	while (line != L"[static]") {
		getline(fileStream, line);
		const vector<wstring> tokens = SplitStr(line, L"\t");
		try {
			if (tokens[0].length() == 4)
				oncoming.speeds.push(stof(tokens[ONCOMING_SPEED]));
		}
		catch (...) {
			fileStream.close();
			throw Exception(L"Invalid speed value: '" + tokens[ONCOMING_SPEED] + L"'");
		}
	}

	fileStream.close();
	return oncoming;
}


// Utils //////////
void ROM::ReadJSON(const wstring& file, rapidjson::Document& json) {
	ifstream fileStream(file, ifstream::binary);
	if (!fileStream.good())
		throw Exception(L"Error opening file: " + file);

	string jsonStr((istreambuf_iterator<char>(fileStream)), istreambuf_iterator<char>());
	fileStream.close();

	json.Parse(jsonStr.c_str());
	if (json.HasParseError())
		throw Exception(L"Error parsing addresses file '" + file + L"': " + to_wstring(json.GetParseError()));
}

void ROM::ReadAddressesFile(const wstring& file, const boolean& isCommon) {
	if (isCommon)
		this->ReadJSON(file, this->addresses);
	else
		this->ReadJSON(file, this->addressesSpecific);
}