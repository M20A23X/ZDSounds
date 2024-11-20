#include "pch.h"
#include <fstream>

#include "exceptions\\exception.hpp"

#include "rom.hpp"

enum FileValueEnum {
	LOCO_SECITONS_COUNT = 0,
	STATION_KILOMETER_START = 1,
	STATION_KILOMETER_END = 2,
	ONCOMING_SPEED = 3,
	TRACK_LIST_TRACK = 7,
	TRACK_LIST_ORDINATE = 10
};


ROM::ROM() {
	this->_ReadAddressesFile(this->_ADDRESSES_FILE);
}

// Initialization //////////

// InitializeConsist
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

// ReadStations
ROM::Stations ROM::ReadStations(const wstring& routeName) const {
	const wstring file = L"routes\\" + routeName + L"\\start_kilometers.dat";

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
			throw Exception(L"Invalid entry values: '" + tokens[STATION_KILOMETER_START] + L"', '" + tokens[STATION_KILOMETER_END] + L"'");
		}
		finally {
			fileStream.close();
		}
	}

	fileStream.close();
	return stations;
}

// ReadAddressesFile
void ROM::_ReadAddressesFile(const wstring& file) {
	ifstream fileStream(file, ifstream::binary);
	if (!fileStream.good())
		throw Exception(L"Error reading file: " + file);

	string addressesJson((istreambuf_iterator<char>(fileStream)), istreambuf_iterator<char>());
	fileStream.close();

	this->_addresses.Parse(addressesJson.c_str());

	if (this->_addresses.HasParseError()) {
		throw Exception(L"Error parsing addresses file '" + file + L"': " + to_wstring(this->_addresses.GetParseError()));
	}
}

// Common //////////

// GetAddress
uintptr_t ROM::GetAddress(const char* key) const {
	istringstream converter(this->_addresses[key].GetString());
	uintptr_t address;
	converter >> std::hex >> address;
	return address;
}


// ReadOrdinateByTrack
uint32_t ROM::ReadOrdinateByTrack(const uint16_t& track, const wstring& routeName, const bool& isBackward) const {
	wstring line;
	wstring ordinate;

	const wstring file = L"routes\\" + routeName + L"\\route" + to_wstring(isBackward + 1) + L".trk";

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

// ReadConsistUnit
ROM::ConsistUnit ROM::_ReadConsistUnit(const wstring& dir, uint8_t* sectionCountPtr, const bool& isLoco) const {
	ConsistUnit unit;
	uint8_t idxShift = uint8_t(isLoco);

	wstring file = L"zdsounds\\consist\\" + dir + L"\\entity\\axes.dat";
	wstring line;

	wifstream fileStream(file);
	if (!fileStream.good())
		throw Exception(L"Error reading file '" + file + L"'!");

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

// ReadOncoming
ROM::Oncoming ROM::ReadOncomings(const wstring& routeName, const wstring& sceneryName) const {
	const wstring file = L"routes\\" + routeName + L"\\scenaries\\" + sceneryName;

	wifstream fileStream(file);
	if (!fileStream.good())
		throw Exception(L"Error reading file '" + file + L"'!");

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