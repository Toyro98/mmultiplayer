#pragma once

#include "imgui_internal.h"

namespace ImGui 
{
	ImGuiWindow* BeginRawScene(const char* name);
	void EndRawScene();
	bool Hotkey(const char* label, int* k, const ImVec2& size_arg = ImVec2(0, 0));
	void Separator(const float& height);
	void HelpMarker(const char* desc);
	void DummyVertical(const float& height);
	bool SmallArrowButton(const char* str_id, ImGuiDir dir, ImVec2 size);
} 
