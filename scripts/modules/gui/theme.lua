-- CyberEngineTWeaks Mod Manager is a mod manager for Cyber Engine Tweaks based mods

-- Copyright (C) 2021 Mingming Cui
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

---@class theme
local theme  =           {
	Text                                =           { 1   , 0.44, 0.4 , 1    },
	TextDisabled                        =           { 0.48, 0.39, 0.40, 1    },
	WindowBg                            =           { 0.06, 0.04, 0.06, 0.9  },
	ChildBg                             =           { 0.06, 0.04, 0.06, 0.9  },
	PopupBg                             =           { 0   , 0   , 0   , 0    },
	Border                              =           { 0.3 , 0.07, 0.08, 1    },
	BorderShadow                        =           { 0   , 0   , 0   , 0    },
	FrameBg                             =           { 0.57, 0.17, 0.16, 1    },
	FrameBgHovered                      =           { 0.32, 0.09, 0.11, 1    },
	FrameBgActive                       =           { 0.1 , 0.05, 0.05, 1    },
	FrameBgDisabled                     =           { 0.48, 0.39, 0.40, 1    },
	FrameBgHoveredDisabled              =           { 0.48, 0.39, 0.40, 1    },
	FrameBgActiveDisabled               =           { 0.48, 0.39, 0.40, 1    },
	TitleBg                             =           { 0.06, 0.04, 0.06, 0.9  },
	TitleBgActive                       =           { 0.06, 0.04, 0.06, 0.9  },
	TitleBgCollapsed                    =           { 0.06, 0.04, 0.06, 0.9  },
	MenuBarBg                           =           { 0   , 0   , 0   , 0    },
	ScrollbarBg                         =           { 0.06, 0.04, 0.06, 0    },
	ScrollbarGrab                       =           { 0.57, 0.17, 0.16, 1    },
	ScrollbarGrabHovered                =           { 0.57, 0.17, 0.16, 1    },
	ScrollbarGrabActive                 =           { 0.57, 0.17, 0.16, 1    },
	CheckMark                           =           { 1   , 0.44, 0.4 , 1    },
	CheckMarkTrueDisabled               =           { 0.34, 0.22, 0.24, 1    },
	CheckMarkFalseDisabled              =           { 0.48, 0.39, 0.40, 1    },
	SliderGrab                          =           { 0   , 0   , 0   , 0    },
	SliderGrabActive                    =           { 0   , 0   , 0   , 0    },
	Button                              =           { 0.57, 0.17, 0.16, 1    },
	ButtonHovered                       =           { 0.45, 0.13, 0.14, 1    },
	ButtonActive                        =           { 0.57, 0.17, 0.16, 1    },
	Header                              =           { 0   , 0   , 0   , 0    },
	HeaderHovered                       =           { 0.22, 0.64, 0.69, 0.25 },
	HeaderActive                        =           { 0.22, 0.64, 0.69, 0.5  },
	Separator                           =           { 0.29, 0.77, 0.79, 1    },
	SeparatorHovered                    =           { 0.29, 0.77, 0.79, 1    },
	SeparatorActive                     =           { 0.29, 0.77, 0.79, 1    },
	ResizeGrip                          =           { 0.06, 0.04, 0.06, 1    },
	ResizeGripHovered                   =           { 1   , 0.44, 0.4 , 1    },
	ResizeGripActive                    =           { 1   , 0.44, 0.4 , 1    },
	Tab                                 =           { 0   , 0   , 0   , 0    },
	TabHovered                          =           { 0   , 0   , 0   , 0    },
	TabActive                           =           { 0   , 0   , 0   , 0    },
	TabUnfocused                        =           { 0   , 0   , 0   , 0    },
	TabUnfocusedActive                  =           { 0   , 0   , 0   , 0    },
	DockingPreview                      =           { 0   , 0   , 0   , 0    },
	DockingEmptyBg                      =           { 0   , 0   , 0   , 0    },
	PlotLines                           =           { 0   , 0   , 0   , 0    },
	PlotLinesHovered                    =           { 0   , 0   , 0   , 0    },
	PlotHistogram                       =           { 0   , 0   , 0   , 0    },
	PlotHistogramHovered                =           { 0   , 0   , 0   , 0    },
	TextSelectedBg                      =           { 0   , 0   , 0   , 0    },
	DragDropTarget                      =           { 0   , 0   , 0   , 0    },
	NavHighlight                        =           { 0   , 0   , 0   , 0    },
	NavWindowingHighlight               =           { 0   , 0   , 0   , 0    },
	NavWindowingDimBg                   =           { 0   , 0   , 0   , 0    },
	ModalWindowDimBg                    =           { 0   , 0   , 0   , 0    },
	ModalWindowDarkening                =           { 0   , 0   , 0   , 0    },
	COUNT                               =           { 0   , 0   , 0   , 0    },
	CustomToggleOn                      =           { 0.29, 0.77, 0.79, 1    },
	CustomToggleOnHovered               =           { 0.20, 0.56, 0.59, 1    },
	CustomToggleOnText                  =           { 0   , 0   , 0   , 1    },
	CustomToggleOnDisable               =           { 0.04, 0.11, 0.12, 1    },
	CustomToggleOnDisableHovered        =           { 0.05, 0.16, 0.16, 1    },
	CustomToggleOnDisableText           =           { 0.06, 0.18, 0.2 , 1    },
	CustomToggleOff                     =           { 0.57, 0.18, 0.16, 1    },
	CustomToggleOffHovered              =           { 0.45, 0.13, 0.14, 1    },
	CustomToggleOffText                 =           { 1   , 0.44, 0.4 , 1    },
	CustomToggleOffDisable              =           { 0.1 , 0.04, 0.07, 1    },
	CustomToggleOffDisableHovered       =           { 0.16, 0.06, 0.07, 1    },
	CustomToggleOffDisableText          =           { 0.22, 0.07, 0.07, 1    },
	Hidden                              =           { 0   , 0   , 0   , 0    },
}

return theme
