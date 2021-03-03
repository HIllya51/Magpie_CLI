#pragma once
#include "pch.h"


class WindowCapturerBase {
public:
	WindowCapturerBase() {}

	virtual ~WindowCapturerBase() {}

	WindowCapturerBase(const WindowCapturerBase&) = delete;
	WindowCapturerBase(WindowCapturerBase&&) = delete;

	virtual ComPtr<IWICBitmap> GetFrame() = 0;
};
