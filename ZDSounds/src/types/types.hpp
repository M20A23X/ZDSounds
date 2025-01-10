#pragma once

enum OncomingStatusEnum { COMING, HEAD_PASSED_OUR_HEAD, TAIL_PASSED_OUR_HEAD, PASSED };
enum EnvEnum { CABIN, MACHINE, OUTSIDE, COMMON };
enum KR21StateEnum { PLUS_AUTO = 2, PLUS = 1, NEUTRAL = 0, MINUS = 255, MINUS_AUTO = 254 };

struct Point {
	float
		x = 0,
		y = 0,
		z = 0;

	Point() {}
	Point(const Point& point)
		: x{ point.x }, y{ point.y }, z{ point.z } {
	}
	Point(const float& x, const float& y, const float& z)
		: x{ x }, y{ y }, z{ z } {
	}
};

// Values
template <typename T>
struct Value {
	T current;
	T previous;
};


struct SavePrev {
	virtual void SavePrevious() = 0;
};

