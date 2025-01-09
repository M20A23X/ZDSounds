#pragma once

enum OncomingStatusEnum { COMING, HEAD_PASSED_OUR_HEAD, TAIL_PASSED_OUR_HEAD, PASSED };
enum EnvEnum { CABIN, MACHINE, OUTSIDE, COMMON };
enum KR21StateEnum { PLUS_AUTO = 2, PLUS = 1, NEUTRAL = 0, MINUS = -1, MINUS_AUTO = -2 };

// Entity
struct Point {
	float
		x = 0.0f,
		y = 0.0f,
		z = 0.0f;

	Point() {}
	Point(const Point& point)
		: x{ point.x }, y{ point.y }, z{ point.z } {
	}
};

struct Entity {
	Point point;
	EnvEnum env;
	float volume;
};

// Oncoming

// Values
template <typename T>
struct Value {
	T current;
	T previous;
};


struct SavePrev {
	virtual void SavePrevious() = 0;
};

