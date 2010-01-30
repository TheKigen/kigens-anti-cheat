/*
    Kigen's Anti-Cheat RCON Module
    Copyright (C) 2007-2010 Max Krivanek

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#define RCON

new Handle:g_hRCONCrash;
new bool:g_bRCONPreventEnabled = false;
new g_iMinFail = 5;
new g_iMaxFail = 20;
new g_iMinFailTime = 30;
new g_iRCONStatus;

//- Plugin Functions -//

RCON_OnPluginStart()
{
	g_hRCONCrash = FindConVar("kac_rcon_crashprevent");
	if ( g_hRCONCrash == INVALID_HANDLE )
		g_hRCONCrash = CreateConVar("kac_rcon_crashprevent", "0", "Enable RCON crash prevention.");
	else
		g_bRCONPreventEnabled = GetConVarBool(g_hRCONCrash);

	HookConVarChange(g_hRCONCrash, RCON_CrashPrevent);

	if ( g_bRCONPreventEnabled )
		g_iRCONStatus = Status_Register(KAC_RCONPREVENT, KAC_ON);
	else
		g_iRCONStatus = Status_Register(KAC_RCONPREVENT, KAC_OFF);
}

RCON_OnPluginEnd()
{
}

//- Hooks -//

public RCON_CrashPrevent(Handle:convar, const String:oldValue[], const String:newValue[])
{
	new bool:f_bEnable = GetConVarBool(convar);
	if ( f_bEnable == g_bRCONPreventEnabled )
		return;

	if ( f_bEnable )
	{
		decl Handle:f_hConVar;
		f_hConVar = FindConVar("sv_rcon_minfailuretime");
		if ( f_hConVar != INVALID_HANDLE )
		{
			g_iMinFailTime = GetConVarInt(f_hConVar);
			SetConVarBounds(f_hConVar, ConVarBound_Upper, true, 1.0);
			SetConVarInt(f_hConVar, 1); // Setting this so we don't track these failures longer than we need to. - Kigen
		}
	
		f_hConVar = FindConVar("sv_rcon_minfailures");
		if ( f_hConVar != INVALID_HANDLE )
		{
			g_iMinFail =  GetConVarInt(f_hConVar);
			SetConVarBounds(f_hConVar, ConVarBound_Upper, true, 99999.0);
			SetConVarBounds(f_hConVar, ConVarBound_Lower, true, 99999.0);
			SetConVarInt(f_hConVar, 99999);
		}
	
		f_hConVar = FindConVar("sv_rcon_maxfailures");
		if ( f_hConVar != INVALID_HANDLE )
		{
			g_iMaxFail = GetConVarInt(f_hConVar);
			SetConVarBounds(f_hConVar, ConVarBound_Upper, true, 99999.0);
			SetConVarBounds(f_hConVar, ConVarBound_Lower, true, 99999.0);
			SetConVarInt(f_hConVar, 99999);
		}
		g_bRCONPreventEnabled = true;
		Status_Report(g_iRCONStatus, KAC_ON);
	}
	else
	{
		decl Handle:f_hConVar;
		f_hConVar = FindConVar("sv_rcon_minfailuretime");
		if ( f_hConVar != INVALID_HANDLE )
		{
			SetConVarBounds(f_hConVar, ConVarBound_Upper, false);
			SetConVarInt(f_hConVar, g_iMinFailTime); // Setting this so we don't track these failures longer than we need to. - Kigen
		}
	
		f_hConVar = FindConVar("sv_rcon_minfailures");
		if ( f_hConVar != INVALID_HANDLE )
		{
			SetConVarBounds(f_hConVar, ConVarBound_Upper, true, 20.0);
			SetConVarBounds(f_hConVar, ConVarBound_Lower, true, 1.0);
			SetConVarInt(f_hConVar, g_iMinFail);
		}
	
		f_hConVar = FindConVar("sv_rcon_maxfailures");
		if ( f_hConVar != INVALID_HANDLE )
		{
			SetConVarBounds(f_hConVar, ConVarBound_Upper, true, 20.0);
			SetConVarBounds(f_hConVar, ConVarBound_Lower, true, 1.0);
			SetConVarInt(f_hConVar, g_iMaxFail);
		}
		g_bRCONPreventEnabled = false;
		Status_Report(g_iRCONStatus, KAC_OFF);
	}
}

//- End of File -//
