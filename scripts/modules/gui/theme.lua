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
local CETMM = require("modules/CETMM")
local options = CETMM.GetOptions()

---@class theme_default
local theme_default  =           {
	Text                                =           { 1   , 0.44, 0.4 , 1    },
	TextDisabled                        =           { 0.48, 0.39, 0.40, 1    },
	WindowBg                            =           { 0.06, 0.04, 0.06, 0.9  },
	ChildBg                             =           { 0.06, 0.04, 0.06, 0.9  },
	PopupBg                             =           { 0.06, 0.04, 0.06, 0.9  },
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
	Header                              =           { 0.22, 0.64, 0.69, 0.2  },
	HeaderHovered                       =           { 0.22, 0.64, 0.69, 0.3  },
	HeaderActive                        =           { 0.22, 0.64, 0.69, 0.5  },
	Separator                           =           { 0.3 , 0.07, 0.08, 1    },
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
	CustomToggleOnActive                =           { 0.29, 0.77, 0.79, 1    },
	CustomToggleOnText                  =           { 0   , 0   , 0   , 1    },
	CustomToggleOnDisable               =           { 0.04, 0.11, 0.12, 1    },
	CustomToggleOnDisableHovered        =           { 0.05, 0.16, 0.16, 1    },
	CustomToggleOnDisableText           =           { 0.06, 0.18, 0.2 , 1    },
	CustomToggleOff                     =           { 0.57, 0.18, 0.16, 1    },
	CustomToggleOffHovered              =           { 0.45, 0.13, 0.14, 1    },
	CustomToggleOffDisable              =           { 0.1 , 0.04, 0.07, 1    },
	CustomToggleOffDisableHovered       =           { 0.16, 0.06, 0.07, 1    },
	CustomToggleOffDisableText          =           { 0.22, 0.07, 0.07, 1    },
	AltText                             =           { 0.29, 0.77, 0.79, 1    },
	Hidden                              =           { 0   , 0   , 0   , 0    },
}

---@class theme_ua_special
local theme_ua_special =           {
	Text                                =           { 0.96, 0.81, 0.00, 1    },
	TextDisabled                        =           { 0.48, 0.39, 0.40, 1    },
	WindowBg                            =           { 0.05, 0.11, 0.18, 0.9  },
	ChildBg                             =           { 0.05, 0.11, 0.18, 0.9  },
	PopupBg                             =           { 0.05, 0.11, 0.18, 0.9  },
	Border                              =           { 0.60, 0.51, 0.00, 1    },
	BorderShadow                        =           { 0   , 0   , 0   , 0    },
	FrameBg                             =           { 0.00, 0.35, 0.71, 1    },
	FrameBgHovered                      =           { 0.00, 0.44, 0.90, 1    },
	FrameBgActive                       =           { 0.00, 0.35, 0.71, 1    },
	FrameBgDisabled                     =           { 0.48, 0.39, 0.40, 1    },
	FrameBgHoveredDisabled              =           { 0.48, 0.39, 0.40, 1    },
	FrameBgActiveDisabled               =           { 0.48, 0.39, 0.40, 1    },
	TitleBg                             =           { 0.05, 0.11, 0.18, 0.9  },
	TitleBgActive                       =           { 0.05, 0.11, 0.18, 0.9  },
	TitleBgCollapsed                    =           { 0.05, 0.11, 0.18, 0.9  },
	MenuBarBg                           =           { 0.05, 0.11, 0.18, 0.9  },
	ScrollbarBg                         =           { 0.06, 0.04, 0.06, 0    },
	ScrollbarGrab                       =           { 0.00, 0.35, 0.71, 1    },
	ScrollbarGrabHovered                =           { 0.00, 0.44, 0.90, 1    },
	ScrollbarGrabActive                 =           { 0.00, 0.35, 0.71, 1    },
	CheckMark                           =           { 0.96, 0.81, 0.00, 1    },
	CheckMarkTrueDisabled               =           { 0.34, 0.22, 0.24, 1    },
	CheckMarkFalseDisabled              =           { 0.48, 0.39, 0.40, 1    },
	SliderGrab                          =           { 0   , 0   , 0   , 0    },
	SliderGrabActive                    =           { 0   , 0   , 0   , 0    },
	Button                              =           { 0.00, 0.35, 0.71, 1    },
	ButtonHovered                       =           { 0.00, 0.44, 0.90, 1    },
	ButtonActive                        =           { 0.00, 0.35, 0.71, 1    },
	Header                              =           { 0.00, 0.21, 0.43, 0.6 },
	HeaderHovered                       =           { 0.00, 0.21, 0.43, 0.9 },
	HeaderActive                        =           { 0.00, 0.21, 0.43, 0.9  },
	Separator                           =           { 0.60, 0.51, 0.00, 0.5  },
	SeparatorHovered                    =           { 0.29, 0.77, 0.79, 1    },
	SeparatorActive                     =           { 0.29, 0.77, 0.79, 1    },
	ResizeGrip                          =           { 0.05, 0.11, 0.18, 1    },
	ResizeGripHovered                   =           { 0.96, 0.81, 0.00, 1    },
	ResizeGripActive                    =           { 0.96, 0.81, 0.00, 1    },
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
	CustomToggleOn                      =           { 0.96, 0.81, 0.00, 1    },
	CustomToggleOnHovered               =           { 0.81, 0.67, 0.00, 1    },
	CustomToggleOnActive                =           { 0.96, 0.81, 0.00, 1    },
	CustomToggleOnText                  =           { 0.00, 0.44, 0.90, 1    },
	CustomToggleOnDisable               =           { 0.04, 0.11, 0.12, 1    },
	CustomToggleOnDisableHovered        =           { 0.05, 0.16, 0.16, 1    },
	CustomToggleOnDisableText           =           { 0.06, 0.18, 0.2 , 1    },
	CustomToggleOff                     =           { 0.57, 0.18, 0.16, 1    },
	CustomToggleOffHovered              =           { 0.45, 0.13, 0.14, 1    },
	CustomToggleOffDisable              =           { 0.1 , 0.04, 0.07, 1    },
	CustomToggleOffDisableHovered       =           { 0.16, 0.06, 0.07, 1    },
	CustomToggleOffDisableText          =           { 0.22, 0.07, 0.07, 1    },
	AltText                             =           { 0.00, 0.44, 0.90, 1    },
	Hidden                              =           { 0   , 0   , 0   , 0    },
}

---@class theme_white
local theme_white =           {
	DEF_Text                                =           { 1   , 1   , 1   , 1    },
	DEF_TextDisabled                        =           { 1   , 1   , 1   , 1    },
	DEF_WindowBg                            =           { 1   , 1   , 1   , 1    },
	DEF_ChildBg                             =           { 1   , 1   , 1   , 1    },
	DEF_PopupBg                             =           { 1   , 1   , 1   , 1    },
	DEF_Border                              =           { 1   , 1   , 1   , 1    },
	DEF_BorderShadow                        =           { 1   , 1   , 1   , 1    },
	DEF_FrameBg                             =           { 1   , 1   , 1   , 1    },
	DEF_FrameBgHovered                      =           { 1   , 1   , 1   , 1    },
	DEF_FrameBgActive                       =           { 1   , 1   , 1   , 1    },
	DEF_FrameBgDisabled                     =           { 1   , 1   , 1   , 1    },
	DEF_FrameBgHoveredDisabled              =           { 1   , 1   , 1   , 1    },
	DEF_FrameBgActiveDisabled               =           { 1   , 1   , 1   , 1    },
	DEF_TitleBg                             =           { 1   , 1   , 1   , 1    },
	DEF_TitleBgActive                       =           { 1   , 1   , 1   , 1    },
	DEF_TitleBgCollapsed                    =           { 1   , 1   , 1   , 1    },
	DEF_MenuBarBg                           =           { 1   , 1   , 1   , 1    },
	DEF_ScrollbarBg                         =           { 1   , 1   , 1   , 1    },
	DEF_ScrollbarGrab                       =           { 1   , 1   , 1   , 1    },
	DEF_ScrollbarGrabHovered                =           { 1   , 1   , 1   , 1    },
	DEF_ScrollbarGrabActive                 =           { 1   , 1   , 1   , 1    },
	DEF_CheckMark                           =           { 1   , 1   , 1   , 1    },
	DEF_CheckMarkTrueDisabled               =           { 1   , 1   , 1   , 1    },
	DEF_CheckMarkFalseDisabled              =           { 1   , 1   , 1   , 1    },
	DEF_SliderGrab                          =           { 1   , 1   , 1   , 1    },
	DEF_SliderGrabActive                    =           { 1   , 1   , 1   , 1    },
	DEF_Button                              =           { 1   , 1   , 1   , 1    },
	DEF_ButtonHovered                       =           { 1   , 1   , 1   , 1    },
	DEF_ButtonActive                        =           { 1   , 1   , 1   , 1    },
	DEF_Header                              =           { 1   , 1   , 1   , 1    },
	DEF_HeaderHovered                       =           { 1   , 1   , 1   , 1    },
	DEF_HeaderActive                        =           { 1   , 1   , 1   , 1    },
	DEF_Separator                           =           { 1   , 1   , 1   , 1    },
	DEF_SeparatorHovered                    =           { 1   , 1   , 1   , 1    },
	DEF_SeparatorActive                     =           { 1   , 1   , 1   , 1    },
	DEF_ResizeGrip                          =           { 1   , 1   , 1   , 1    },
	DEF_ResizeGripHovered                   =           { 1   , 1   , 1   , 1    },
	DEF_ResizeGripActive                    =           { 1   , 1   , 1   , 1    },
	DEF_Tab                                 =           { 1   , 1   , 1   , 1    },
	DEF_TabHovered                          =           { 1   , 1   , 1   , 1    },
	DEF_TabActive                           =           { 1   , 1   , 1   , 1    },
	DEF_TabUnfocused                        =           { 1   , 1   , 1   , 1    },
	DEF_TabUnfocusedActive                  =           { 1   , 1   , 1   , 1    },
	DEF_DockingPreview                      =           { 1   , 1   , 1   , 1    },
	DEF_DockingEmptyBg                      =           { 1   , 1   , 1   , 1    },
	DEF_PlotLines                           =           { 1   , 1   , 1   , 1    },
	DEF_PlotLinesHovered                    =           { 1   , 1   , 1   , 1    },
	DEF_PlotHistogram                       =           { 1   , 1   , 1   , 1    },
	DEF_PlotHistogramHovered                =           { 1   , 1   , 1   , 1    },
	DEF_TextSelectedBg                      =           { 1   , 1   , 1   , 1    },
	DEF_DragDropTarget                      =           { 1   , 1   , 1   , 1    },
	DEF_NavHighlight                        =           { 1   , 1   , 1   , 1    },
	DEF_NavWindowingHighlight               =           { 1   , 1   , 1   , 1    },
	DEF_NavWindowingDimBg                   =           { 1   , 1   , 1   , 1    },
	DEF_ModalWindowDimBg                    =           { 1   , 1   , 1   , 1    },
	DEF_ModalWindowDarkening                =           { 1   , 1   , 1   , 1    },
	DEF_COUNT                               =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOn                      =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOnHovered               =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOnActive                =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOnText                  =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOnDisable               =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOnDisableHovered        =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOnDisableText           =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOff                     =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOffHovered              =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOffDisable              =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOffDisableHovered       =           { 1   , 1   , 1   , 1    },
	DEF_CustomToggleOffDisableText          =           { 1   , 1   , 1   , 1    },
	DEF_AltText                             =           { 1   , 1   , 1   , 1    },
	DEF_Hidden                              =           { 1   , 1   , 1   , 1    },
	HVR_Text                                =           { 0.20, 0.20, 0.20, 1    },
	HVR_TextDisabled                        =           { 0.48, 0.39, 0.40, 1    },
	HVR_WindowBg                            =           { 1   , 1   , 1   , 0.9  },
	HVR_ChildBg                             =           { 1   , 1   , 1   , 0.9  },
	HVR_PopupBg                             =           { 1   , 1   , 1   , 0.9  },
	HVR_Border                              =           { 0.5 , 0.5 , 0.5 , 1    },
	HVR_BorderShadow                        =           { 0   , 0   , 0   , 0    },
	HVR_FrameBg                             =           { 1   , 1   , 1   , 1    },
	HVR_FrameBgHovered                      =           { 0.80, 0.80, 0.80, 1    },
	HVR_FrameBgActive                       =           { 1   , 1   , 1   , 1    },
	HVR_FrameBgDisabled                     =           { 0.48, 0.39, 0.40, 1    },
	HVR_FrameBgHoveredDisabled              =           { 0.48, 0.39, 0.40, 1    },
	HVR_FrameBgActiveDisabled               =           { 0.48, 0.39, 0.40, 1    },
	HVR_TitleBg                             =           { 1   , 1   , 1   , 0.9  },
	HVR_TitleBgActive                       =           { 1   , 1   , 1   , 0.9  },
	HVR_TitleBgCollapsed                    =           { 1   , 1   , 1   , 0.9  },
	HVR_MenuBarBg                           =           { 1   , 1   , 1   , 0.9  },
	HVR_ScrollbarBg                         =           { 0.06, 0.04, 0.06, 0    },
	HVR_ScrollbarGrab                       =           { 1   , 1   , 1   , 1    },
	HVR_ScrollbarGrabHovered                =           { 0.80, 0.80, 0.80, 1    },
	HVR_ScrollbarGrabActive                 =           { 1   , 1   , 1   , 1    },
	HVR_CheckMark                           =           { 0.20, 0.20, 0.20, 1    },
	HVR_CheckMarkTrueDisabled               =           { 0.20, 0.20, 0.20, 1    },
	HVR_CheckMarkFalseDisabled              =           { 0.20, 0.20, 0.20, 1    },
	HVR_SliderGrab                          =           { 0   , 0   , 0   , 0    },
	HVR_SliderGrabActive                    =           { 0   , 0   , 0   , 0    },
	HVR_Button                              =           { 1   , 1   , 1   , 1    },
	HVR_ButtonHovered                       =           { 0.80, 0.80, 0.80, 1    },
	HVR_ButtonActive                        =           { 1   , 1   , 1   , 1    },
	HVR_Header                              =           { 0.80, 0.80, 0.80, 0.6  },
	HVR_HeaderHovered                       =           { 0.80, 0.80, 0.80, 0.9  },
	HVR_HeaderActive                        =           { 0.80, 0.80, 0.80, 0.9  },
	HVR_Separator                           =           { 0.5 , 0.5 , 0.5 , 1    },
	HVR_SeparatorHovered                    =           { 0.5 , 0.5 , 0.5 , 1    },
	HVR_SeparatorActive                     =           { 0.5 , 0.5 , 0.5 , 1    },
	HVR_ResizeGrip                          =           { 0.80, 0.80, 0.80, 1    },
	HVR_ResizeGripHovered                   =           { 0.70, 0.70, 0.70, 1    },
	HVR_ResizeGripActive                    =           { 0.70, 0.70, 0.70, 1    },
	HVR_Tab                                 =           { 0   , 0   , 0   , 0    },
	HVR_TabHovered                          =           { 0   , 0   , 0   , 0    },
	HVR_TabActive                           =           { 0   , 0   , 0   , 0    },
	HVR_TabUnfocused                        =           { 0   , 0   , 0   , 0    },
	HVR_TabUnfocusedActive                  =           { 0   , 0   , 0   , 0    },
	HVR_DockingPreview                      =           { 0   , 0   , 0   , 0    },
	HVR_DockingEmptyBg                      =           { 0   , 0   , 0   , 0    },
	HVR_PlotLines                           =           { 0   , 0   , 0   , 0    },
	HVR_PlotLinesHovered                    =           { 0   , 0   , 0   , 0    },
	HVR_PlotHistogram                       =           { 0   , 0   , 0   , 0    },
	HVR_PlotHistogramHovered                =           { 0   , 0   , 0   , 0    },
	HVR_TextSelectedBg                      =           { 0   , 0   , 0   , 0    },
	HVR_DragDropTarget                      =           { 0   , 0   , 0   , 0    },
	HVR_NavHighlight                        =           { 0   , 0   , 0   , 0    },
	HVR_NavWindowingHighlight               =           { 0   , 0   , 0   , 0    },
	HVR_NavWindowingDimBg                   =           { 0   , 0   , 0   , 0    },
	HVR_ModalWindowDimBg                    =           { 0   , 0   , 0   , 0    },
	HVR_ModalWindowDarkening                =           { 0   , 0   , 0   , 0    },
	HVR_COUNT                               =           { 0   , 0   , 0   , 0    },
	HVR_CustomToggleOn                      =           { 0.80, 0.80, 0.80, 1    },
	HVR_CustomToggleOnHovered               =           { 0.70, 0.70, 0.70, 1    },
	HVR_CustomToggleOnActive                =           { 0.80, 0.80, 0.80, 1    },
	HVR_CustomToggleOnText                  =           { 0.20, 0.20, 0.20, 1    },
	HVR_CustomToggleOnDisable               =           { 0.04, 0.11, 0.12, 1    },
	HVR_CustomToggleOnDisableHovered        =           { 0.05, 0.16, 0.16, 1    },
	HVR_CustomToggleOnDisableText           =           { 0.06, 0.18, 0.2 , 1    },
	HVR_CustomToggleOff                     =           { 0.57, 0.18, 0.16, 1    },
	HVR_CustomToggleOffHovered              =           { 0.45, 0.13, 0.14, 1    },
	HVR_CustomToggleOffDisable              =           { 0.1 , 0.04, 0.07, 1    },
	HVR_CustomToggleOffDisableHovered       =           { 0.16, 0.06, 0.07, 1    },
	HVR_CustomToggleOffDisableText          =           { 0.22, 0.07, 0.07, 1    },
	HVR_AltText                             =           { 0.80, 0.80, 0.80, 1    },
	HVR_Hidden                              =           { 0   , 0   , 0   , 0    },
	HVR = false,
	HVRBefore = nil,
}

function theme_white.Push(self)
	if options.m_theme ~= "white" then
		return
	end
	if (self.HVRBefore == nil) or (self.HVR ~= self.HVRBefore and not self.HVR) then
		for key, value in pairs(self) do
			if string.find(key, "^DEF_") then
				self[string.gsub(key, "^DEF_", "")] = value
			end
		end
		self.HVRBefore = false
	elseif (self.HVR ~= self.HVRBefore and self.HVR) then
		for key, value in pairs(self) do
			if string.find(key, "^HVR_") then
				self[string.gsub(key, "^HVR_", "")] = value
			end
		end
		self.HVRBefore = true
	end
end

---@class theme:theme_default
local theme = {}
function theme.Push(self) end

local function load_impl(aTheme)
	for key, value in pairs(aTheme) do
		theme[key] = value
	end
end


function theme.Load()
	if options.m_theme == "ua_special" then
		load_impl(theme_ua_special)
	elseif options.m_theme == "white" then
		load_impl(theme_white)
	else
		load_impl(theme_default)
	end
end

function theme.LoadDefault()
	load_impl(theme_default)
end

return theme
