/*
    Kigen's Anti-Cheat RCON Module
    Copyright (C) 2007-2011 CodingDirect LLC

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

#define HOTFIX

Hotfix_OnPluginStart()
{
	if ( g_iGame == GAME_CSS )
	{
		RegConsoleCmd("kill", Hotfix_Generic);
		RegConsoleCmd("spectate", Hotfix_Generic);
		RegConsoleCmd("jointeam", Hotfix_Generic);
		RegConsoleCmd("explode", Hotfix_Generic);
	}
}

Hotfix_Suicide(client)
{
	// Copyright (c) 2011 CodingDirect LLC - This code was written by Kigen
	if ( client > 0 && IsClientInGame(client) && IsPlayerAlive(client) )
	{
		new ent = CreateEntityByName("point_hurt");
		new String:name[32];
		if ( ent )
		{
			Format(name, sizeof(name), "hurtmemore%d", client);
			DispatchKeyValue(client, "targetname", name);
			DispatchKeyValue(ent, "DamageTarget", name);
			DispatchKeyValue(ent, "Damage", "99999");
			DispatchKeyValue(ent, "DamageType", "0"); // Generic damage
			DispatchSpawn(ent);
			AcceptEntityInput(ent, "Hurt", client);
			RemoveEdict(ent);
		}
	}
}

public Action:Hotfix_Generic(client, args)
{
	Hotfix_Suicide(client);
	return Plugin_Continue;
}

public Hotfix_ForceSuicide(Handle:plugin, args)
{
	new client = GetNativeCell(1);
	if ( client < 1 || client > MaxClients || !IsClientInGame(client) )
		ThrowNativeError(0, "Invalid client index %d", client);
	Hotfix_Suicide(client);
}
