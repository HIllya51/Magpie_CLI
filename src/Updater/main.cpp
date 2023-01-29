// Copyright (c) 2021 - present, Liu Xu
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

#include "pch.h"
#include <shellapi.h>
#include "Version.h"

static bool FileExists(const wchar_t* fileName) noexcept {
	DWORD attrs = GetFileAttributes(fileName);
	// 排除文件夹
	return (attrs != INVALID_FILE_ATTRIBUTES) && !(attrs & FILE_ATTRIBUTE_DIRECTORY);
}

static std::string UTF16ToUTF8(std::wstring_view str) noexcept {
	if (str.empty()) {
		return {};
	}

	int convertResult = WideCharToMultiByte(CP_UTF8, 0, str.data(), (int)str.size(),
		nullptr, 0, nullptr, nullptr);
	if (convertResult <= 0) {
		assert(false);
		return {};
	}

	std::string result(convertResult + 10, L'\0');
	convertResult = WideCharToMultiByte(CP_UTF8, 0, str.data(), (int)str.size(),
		result.data(), (int)result.size(), nullptr, nullptr);
	if (convertResult <= 0) {
		assert(false);
		return {};
	}

	result.resize(convertResult);
	return result;
}

// 等待 Magpie.exe 退出
static bool WaitForMagpieToExit() noexcept {
	static constexpr const wchar_t* SINGLE_INSTANCE_MUTEX_NAME = L"{4C416227-4A30-4A2F-8F23-8701544DD7D6}";

	HANDLE hSingleInstanceMutex = CreateMutex(nullptr, FALSE, SINGLE_INSTANCE_MUTEX_NAME);
	if (hSingleInstanceMutex) {
		WaitForSingleObject(hSingleInstanceMutex, 10000);
		ReleaseMutex(hSingleInstanceMutex);
	}

	// 即使 mutex 已被释放，Magpie.exe 仍有可能正在后台执行清理工作
	// 尝试删除 Magpie.exe，直到成功为止
	for (int i = 0; i < 1000; ++i) {
		if (DeleteFile(L"Magpie.exe")) {
			return true;
		}

		Sleep(10);
	}

	// 超时
	return false;
}

int APIENTRY wWinMain(
	_In_ HINSTANCE /*hInstance*/,
	_In_opt_ HINSTANCE /*hPrevInstance*/,
	_In_ wchar_t* lpCmdLine,
	_In_ int /*nCmdShow*/)
{
	if (!lpCmdLine || lpCmdLine[0] == 0) {
		// 参数为空则什么事都不做，以防止用户手动启动 Updater.exe
		return 0;
	}

	Version oldVersion;
	if (!oldVersion.Parse(UTF16ToUTF8(lpCmdLine))) {
		return 1;
	}

	// 将当前目录设为程序所在目录
	{
		wchar_t curDir[MAX_PATH] = { 0 };
		GetModuleFileName(NULL, curDir, MAX_PATH);

		for (int i = lstrlenW(curDir) - 1; i >= 0; --i) {
			if (curDir[i] == L'\\' || curDir[i] == L'/') {
				break;
			} else {
				curDir[i] = L'\0';
			}
		}

		SetCurrentDirectory(curDir);
	}

	// 检查 Updater.exe 所处环境
	if (!FileExists(L"Magpie.exe") || !FileExists(L"update\\Magpie.exe")) {
		return 1;
	}
	
	if (!WaitForMagpieToExit()) {
		return 1;
	}

	// 删除旧版本文件
	

	MessageBox(NULL, lpCmdLine, L"test", MB_OK);
	return 0;
}
