/*
    Kigen's Anti-Cheat Network Module
    Copyright (C) 2007-2010 CodingDirect LLC

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

#define NETWORK

// Old Network version, to be replaced soon.

//- Global Variables -//
new Handle:g_hUpdateFile = INVALID_HANDLE;
new Handle:g_hSocket = INVALID_HANDLE;
new Handle:g_hTimer = INVALID_HANDLE;
new Handle:g_hVTimer = INVALID_HANDLE;
#if defined PRIVATE
new bool:g_bVCheckDone = true;
#else
new bool:g_bVCheckDone = false;
#endif
new bool:g_bChecked[MAXPLAYERS+1] = {false, ...};
new g_iInError = 0;
new g_iNetStatus;
new String:g_sMirrors[][] = { "kigenac.com", "nauc.info" };
new g_iCurrentMirror;

new bool:InUpdate = false;
new String:UpdatePath[256];

#define REQUIRE_EXTENSIONS
#include <socket>

//- Plugin Functions -//

Network_OnPluginStart()
{
	g_hTimer = CreateTimer(5.0, Network_Timer, _, TIMER_REPEAT);
	g_iNetStatus = Status_Register(KAC_NETMOD, KAC_ON);

	RegAdminCmd("kac_net_status", Network_Checked, ADMFLAG_GENERIC, "Reports who has been checked");
}

Network_OnPluginEnd()
{
	if ( g_hTimer != INVALID_HANDLE )
		CloseHandle(g_hTimer);
	if ( g_hVTimer != INVALID_HANDLE )
		CloseHandle(g_hVTimer);
	if ( g_hSocket != INVALID_HANDLE )
		CloseHandle(g_hSocket);
}

//- Client Functions -//

Network_OnClientDisconnect(client)
{
	g_bChecked[client] = false;
}

//- Commands -//

public Action:Network_Checked(client, args)
{
	new String:f_sName[64], String:f_sAuthID[64];
	for(new i=1;i<=MaxClients;i++)
		if ( g_bInGame[i] && GetClientName(i, f_sName, sizeof(f_sName)) && GetClientAuthString(i, f_sAuthID, sizeof(f_sAuthID)) )
			ReplyToCommand(client, "%s (%s): %s", f_sName, f_sAuthID, (g_bChecked[i]) ? "Checked" : "Waiting");

	if ( !g_bIsNewSM )
		ReplyToCommand(client, "Your SourceMod version is out of date.  Please update SourceMod to 1.3 or later.");

	return Plugin_Handled;
}

//- Timer Functions -//

public Action:Network_Timer(Handle:timer, any:we)
{
	if ( g_iInError > 0 )
	{
		g_iInError--;
		return Plugin_Continue;
	}

	decl Handle:f_hTemp;
	f_hTemp = g_hSocket;
	if ( f_hTemp != INVALID_HANDLE )
	{
		g_hSocket = INVALID_HANDLE;
		CloseHandle(f_hTemp);
	}

	if ( !g_bVCheckDone ) // If SourceMod is older than 1.3 we will not update.  But we will still check clients.
	{
		g_iInError = 12; // Wait 30 seconds.
		g_hSocket = SocketCreate(SOCKET_TCP, Network_OnSockErrVer);
		SocketConnect(g_hSocket, Network_OnSockConnVer, Network_OnSockRecvVer, Network_OnSockDiscVer, "master.kigenac.com", 9652);
		LogMessage("Checking version....");
		return Plugin_Continue;
	}

	for(new i=1;i<=MaxClients;i++)
	{
		if ( g_bAuthorized[i] && !g_bChecked[i] )
		{
			g_iInError = 1;
			g_hSocket = SocketCreate(SOCKET_TCP, Network_OnSocketError);
			SocketSetArg(g_hSocket, i);
			SocketConnect(g_hSocket, Network_OnSocketConnect, Network_OnSocketReceive, Network_OnSocketDisconnect, "master.kigenac.com", 9652);
			return Plugin_Continue;
		}
	}
	return Plugin_Continue;
}

public Action:Network_VTimer(Handle:timer, any:we)
{
	g_bVCheckDone = false;
	return Plugin_Stop;
}

public Action:Network_Reminder(Handle:timer, any:we)
{
	KAC_PrintToChatAdmins(KAC_SMOUTOFDATE);
	return Plugin_Continue;
}

//- Socket Functions -//

public Network_OnSockDiscVer(Handle:socket, any:we)
{
	if ( !g_bVCheckDone )
		g_iInError = 12;
	g_hSocket = INVALID_HANDLE;
	CloseHandle(socket);
}

public Network_OnSockErrVer(Handle:socket, const errorType, const errorNum, any:we)
{
	if ( !g_bVCheckDone )
		g_iInError = 12;
	g_hSocket = INVALID_HANDLE;
	LogError("Error received during update: Failed to contact master server.");
	Status_Report(g_iNetStatus, KAC_UNABLETOCONTACT);
	CloseHandle(socket);
}

public Network_OnSockConnVer(Handle:socket, any:we)
{
	if ( !SocketIsConnected(socket) )
	{
		g_iInError = 12;
		g_hSocket = INVALID_HANDLE;
		Status_Report(g_iNetStatus, KAC_UNABLETOCONTACT);
		CloseHandle(socket);
		return;
	}
	new String:buff[15];
	Format(buff, sizeof(buff), "_UPDATE");
	SocketSend(socket, buff, strlen(buff)+1); // Send that \0!
	LogMessage("Connected to KAC Master, requesting update.");
	Status_Report(g_iNetStatus, KAC_ON);
	return;
}

public Network_OnSockRecvVer(Handle:socket, String:data[], const size, any:we)
{
	if ( StrEqual(data, "_SEND") )
	{
		SocketSend(socket, PLUGIN_VERSION, 7);
		LogMessage("Sending version %s to KAC Master.", PLUGIN_VERSION);
	}
	else if ( StrEqual(data, "_UPTODATE") )
	{
		g_bVCheckDone = true;
		g_hVTimer = CreateTimer(14400.0, Network_VTimer); 
		LogMessage("Received that KAC is up-to-date.");
		if ( SocketIsConnected(socket) )
			SocketDisconnect(socket);
	}
	else if ( StrContains(data, "_UPDATING") != -1 )
	{
		if ( SocketIsConnected(socket) )
			SocketDisconnect(socket);

		new String:path[256], String:f_sTemp[64];
		g_iInError = 9999;
		LogMessage("Received that KAC is out of date, updating to newest version.");
		Format(UpdatePath, sizeof(UpdatePath), "%s", data[10]);
		GetPluginFilename(GetMyHandle(), f_sTemp, sizeof(f_sTemp));
		BuildPath(Path_SM , path, sizeof(path), "plugins\\disabled");
		if ( !DirExists(path) )
			if ( !CreateDirectory(path, 0777) )
			{
				LogError("Unable to create disabled folder.");
				Status_Report(g_iNetStatus, KAC_ERROR);
				return;
			}
		StrCat(path, sizeof(path), "\\");
		StrCat(path, sizeof(path), f_sTemp);
		DeleteFile(path);
		g_hUpdateFile = OpenFile(path, "ab"); // Set to ab to avoid issues with devicenull's patch for the upload exploit.
		if ( g_hUpdateFile == INVALID_HANDLE )
		{
			LogError("Failed to create %s", path);
			Status_Report(g_iNetStatus, KAC_ERROR);
			return;
		}
		CloseHandle(g_hSocket);
		g_hSocket = SocketCreate(SOCKET_TCP, Network_OnSockErrDL);
		SocketConnect(g_hSocket, Network_OnSockConnDL, Network_OnSockRecvDL, Network_OnSockDiscDL, g_sMirrors[g_iCurrentMirror], 80);
		
	}
	else
	{
		LogError("Received unknown reply from KAC master during version check, %s.", data);
		g_bVCheckDone = false;
		if ( SocketIsConnected(socket) )
			SocketDisconnect(socket);
		g_iInError = 6;
		Status_Report(g_iNetStatus, KAC_ERROR);
	}
}

public Network_OnSockDiscDL(Handle:socket, any:we)
{
	if ( !InUpdate )
	{
		g_iInError = 12;
		g_hSocket = INVALID_HANDLE;
		LogError("Disconnected from %s without getting update.", g_sMirrors[g_iCurrentMirror]);
		g_iCurrentMirror++;
		if ( g_iCurrentMirror >= sizeof(g_sMirrors) ) // Switch mirrors.
			g_iCurrentMirror = 0;
		Status_Report(g_iNetStatus, KAC_ERROR);
		CloseHandle(socket);
		CloseHandle(g_hUpdateFile);
		return;
	}
	FlushFile(g_hUpdateFile);
	CloseHandle(g_hUpdateFile);
	CloseHandle(socket);
	g_hSocket = INVALID_HANDLE;
	new String:path[256], String:path2[256];
	GetPluginFilename(GetMyHandle(), path, sizeof(path));
	BuildPath(Path_SM , path2, sizeof(path2), "plugins\\disabled\\%s", path);
	BuildPath(Path_SM , path, sizeof(path), "plugins\\%s", path);
	if ( !DeleteFile(path) )
	{
		LogError("Was unable to delete %s.", path);
		Status_Report(g_iNetStatus, KAC_ERROR);
		return;
	}
	if ( !RenameFile(path, path2) )
	{
		LogError("Was unable to rename %s to %s.", path2, path);
		Status_Report(g_iNetStatus, KAC_ERROR);
		return;
	}
	GetPluginFilename(GetMyHandle(), path, sizeof(path));
	path[strlen(path)-4] = '\0';
	InsertServerCommand("sm plugins reload %s", path);
	LogMessage("Update successful.");
}

public Network_OnSockErrDL(Handle:socket, const errorType, const errorNum, any:we)
{
	g_iInError = 12;
	g_hSocket = INVALID_HANDLE;
	LogError("Error received during update: Failed to connect to %s.", g_sMirrors[g_iCurrentMirror]);
	Status_Report(g_iNetStatus, KAC_ERROR);
	g_iCurrentMirror++;
	if ( g_iCurrentMirror >= sizeof(g_sMirrors) ) // Switch mirrors.
		g_iCurrentMirror = 0;
	CloseHandle(socket);
	CloseHandle(g_hUpdateFile);
}

public Network_OnSockConnDL(Handle:socket, any:we)
{
	if ( !SocketIsConnected(socket) )
	{
		LogError("Disconnect on connect to %s", g_sMirrors[g_iCurrentMirror]);
		g_iInError = 12;
		Status_Report(g_iNetStatus, KAC_ERROR);
		g_iCurrentMirror++;
		if ( g_iCurrentMirror > sizeof(g_sMirrors) ) // Switch mirrors.
			g_iCurrentMirror = 0;
		g_hSocket = INVALID_HANDLE;
		CloseHandle(socket);
		CloseHandle(g_hUpdateFile);
		return;
	}
	new String:buff[512];
	Format(buff, sizeof(buff), "GET %s HTTP/1.0\r\nHost: %s\r\nConnection: close\r\n\r\n", UpdatePath, g_sMirrors[g_iCurrentMirror]);
	SocketSend(socket, buff);
	LogMessage("Connected to %s website, requesting update file.", g_sMirrors[g_iCurrentMirror]);
	Status_Report(g_iNetStatus, KAC_ON);
	return;
}

public Network_OnSockRecvDL(Handle:socket, String:data[], const size, any:we)
{
	new pos = 0;
	if ( !InUpdate )
	{
		pos = StrContains(data, "\r\n\r\n");
		if ( pos == -1 )
			return;
		pos += 4;
		InUpdate = true;
	}
	for(new i=pos;i<size;i++)
		WriteFileCell(g_hUpdateFile, _:data[i], 1);
}


public Network_OnSocketConnect(Handle:socket, any:client)
{
	if ( !SocketIsConnected(socket) )
		return;

	decl String:f_sAuthID[64];
	if ( !g_bAuthorized[client] || !GetClientAuthString(client, f_sAuthID, sizeof(f_sAuthID)) )
		SocketDisconnect(socket);
	else
		SocketSend(socket, f_sAuthID, strlen(f_sAuthID)+1); // Send that \0! - Kigen
	Status_Report(g_iNetStatus, KAC_ON);
	return;
}

public Network_OnSocketDisconnect(Handle:socket, any:client)
{
	if ( socket == g_hSocket )
		g_hSocket = INVALID_HANDLE;
	CloseHandle(socket);
	return;
}

public Network_OnSocketReceive(Handle:socket, String:data[], const size, any:client) 
{
	if ( socket == INVALID_HANDLE || !g_bAuthorized[client] )
		return;

	decl String:f_sName[64], String:f_sAuthID[64], String:f_sBuffer[256];
	GetClientName(client, f_sName, 64);
	GetClientAuthString(client, f_sAuthID, 64);
	g_bChecked[client] = true;
	if ( StrEqual(data, "_BAN") )
	{
		KAC_Translate(client, KAC_GBANNED, f_sBuffer, sizeof(f_sBuffer));
		SetTrieString(g_hDenyArray, f_sAuthID, f_sBuffer);
		KAC_Log("%s (%s) is on the KAC global banlist.", f_sName, f_sAuthID);
		KAC_Kick(client, KAC_GBANNED);
	} 
	else if ( StrEqual(data, "_CAFE") )
	{
		// No longer in use.
	}
	else if ( StrEqual(data, "_OK") )
	{
		// sigh here.
	}
	else
	{
		g_bChecked[client] = false;
		KAC_Log("%s (%s) got unknown reply from KAC master server. Data: %s", f_sName, f_sAuthID, data);
		Status_Report(g_iNetStatus, KAC_ERROR);
	}
	if ( SocketIsConnected(socket) )
		SocketDisconnect(socket);
}

public Network_OnSocketError(Handle:socket, const errorType, const errorNum, any:client)
{
	if ( socket == INVALID_HANDLE )
		return;

	// LogError("Socket Error: eT: %d, eN, %d, c, %d", errorType, errorNum, client);
	if ( g_hSocket == socket )
		g_hSocket = INVALID_HANDLE;
	Status_Report(g_iNetStatus, KAC_UNABLETOCONTACT);
	CloseHandle(socket);
}
