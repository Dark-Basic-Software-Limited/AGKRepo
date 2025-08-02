#define _CRT_SECURE_NO_WARNINGS

#include <windows.h>
#include <stdio.h>
#include <math.h>
#include <cassert>
#include <sys/types.h>
#include <sys/stat.h>
#include <wininet.h>

#include "..\\Windows\\Common.h"

int main( int argc, char* argv[] )
{
	
	// prepare for relative pathing
	char szBuildToolStartDir[1024];
	GetCurrentDirectory(1024, szBuildToolStartDir); // D:\DEV\AGKREPO\AGK\tools\AGKBuildSystem\WindowsTrial\Final
	char szRepoRoot[1024];
	strcpy(szRepoRoot, szBuildToolStartDir);
	strcat(szRepoRoot, "\\..\\..\\..\\..\\..\\");
	SetCurrentDirectory(szRepoRoot);
	GetCurrentDirectory(1024, szRepoRoot);
	char szAGKTrunkDir[1024];
	sprintf(szAGKTrunkDir, "%s\\AGK\\", szRepoRoot);
	SetCurrentDirectoryWithCheck(szAGKTrunkDir);// ("D:\\AGK\\"); // AGKTrunk
	

	// set some path variables
	char szVisualStudio[1024]; sprintf(szVisualStudio, "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\devenv.exe");
	char szDstFolderWinTrial[1024]; sprintf(szDstFolderWinTrial, "%s\\AGK_Build\\Builds\\Studio\\AGKStudioWindowsTrial", szRepoRoot);
	char szSharedFolder[1024]; sprintf(szSharedFolder, "%s\\AGK_Build\\Shared\\WindowsReceive", szRepoRoot);
	char szTemp[1024]; sprintf(szTemp, "%s\\AGK_Build\\Temp", szRepoRoot);

	char rootFolder[1024];
	GetCurrentDirectory(1024, rootFolder);

	int index = -1;
	bool bSingleCommand = false;
	bool bListCommands = true;

startPoint:

	if ( !bListCommands )
	{
		printf( "Enter start point (use 's' to do a single step): " );

		char input[256];
		if ( !fgets(input, 256, stdin) ) Error( "Failed to read input" );
		if ( *input == 's' )
		{
			bSingleCommand = true;
			index = atoi( input+1 );
		}
		else
		{
			index = atoi( input );
		}
	}

	int indexCheck = 0;

	if ( bListCommands ) Message( "Note: Help and command list must be done by the full build first!" );

	//Visual Studio (full version is for the broadcaster)
	if ( index <= ++indexCheck )
	{
		if ( bListCommands ) Message1( "%d: Compile Visual Studio Release (for broadcaster)", indexCheck );
		else
		{
			int status = 0;
			status = RunCmd( indexCheck, szVisualStudio, "AGKWindows.sln /rebuild \"Release|x64\"");
			if ( status != 0 ) Error( "Failed" );
			else Message( "  Success" );
			
			if ( bSingleCommand ) goto endPoint;
		}
	}

	// VSisual Studio Free
	if ( index <= ++indexCheck )
	{
		if ( bListCommands ) Message1( "%d: Compile Visual Studio ReleaseFree", indexCheck );
		else
		{
			int status = 0;
			status = RunCmd( indexCheck, szVisualStudio, "AGKWindows.sln /rebuild \"ReleaseFree|x64\"" );
			if ( status != 0 ) Error( "Failed" );
			else Message( "  Success" );
			
			if ( bSingleCommand ) goto endPoint;
		}
	}

	// Compiler Static Lib (for Studio IDE Trial)
	if (index <= ++indexCheck)
	{
		if (bListCommands) Message1("%d: Compile AGK Compiler Static Lib", indexCheck);
		else
		{
			SetCurrentDirectoryWithCheck("CompilerNew");
			int status = 0;
			status = RunCmd(indexCheck, szVisualStudio, "AGKCompiler2.sln /rebuild \"ReleaseStaticTrial|x64\"");
			if (status != 0) Error("Failed");
			else Message("  Success");
			SetCurrentDirectoryWithCheck("..");

			if (bSingleCommand) goto endPoint;
		}
	}

	// Compiler
	//if ( index <= ++indexCheck )
	//{
	//	if ( bListCommands ) Message1( "%d: Compile AGK Compiler Free", indexCheck );
	//	else
	//	{
		//	SetCurrentDirectoryWithCheck( "CompilerNew" );
		//	int status = 0;
		//	status = RunCmd( indexCheck, szVisualStudio, "AGKCompiler2.sln /rebuild ReleaseFree" );
		//	if ( status != 0 ) Error( "Failed" );
		//	else Message( "  Success" );
		//	SetCurrentDirectoryWithCheck( ".." );
			
		//	if ( bSingleCommand ) goto endPoint;
	//	}
//	}

	// Broadcaster Static Lib (for Studio IDE)
	if (index <= ++indexCheck)
	{
		if (bListCommands) Message1("%d: Compile AGK Broadcaster Static Lib", indexCheck);
		else
		{
			SetCurrentDirectoryWithCheck("Broadcaster\\AGKBroadcaster");
			int status = 0;
			status = RunCmd(indexCheck, szVisualStudio, "AGKBroadcaster.sln /rebuild \"ReleaseStaticLibIDE|x64\"");
			if (status != 0) Error("Failed");
			else Message("  Success");
			SetCurrentDirectoryWithCheck("..\\..");

			if (bSingleCommand) goto endPoint;
		}
	}

	// Broadcaster (for debugging)
	//if ( index <= ++indexCheck )
//	{
		//if ( bListCommands ) Message1( "%d: Compile AGK Broadcaster (for debugging)", indexCheck );
		//else
		//{
			//SetCurrentDirectoryWithCheck( "Broadcaster\\AGKBroadcaster" );
			//int status = 0;
			//status = RunCmd( indexCheck, szVisualStudio, "AGKBroadcaster.sln /rebuild Release" );
			//if ( status != 0 ) Error( "Failed" );
		//	else Message( "  Success" );
		//	SetCurrentDirectoryWithCheck( "..\\.." );
			
		//	if ( bSingleCommand ) goto endPoint;
		//}
	//}


	// interpreter 64-bit
	if ( index <= ++indexCheck )
	{
		if ( bListCommands ) Message1( "%d: Compile Windows interpreter 64-bit ReleaseFree", indexCheck );
		else
		{
			SetCurrentDirectoryWithCheck( "apps\\interpreter" );
			int status = 0;
			status = RunCmd( indexCheck, szVisualStudio, "interpreter.sln /rebuild \"ReleaseFree|x64\"" );
			if ( status != 0 ) Error( "Failed" );
			else Message( "  Success" );
			SetCurrentDirectoryWithCheck( "..\\.." );

			if ( bSingleCommand ) goto endPoint;
		}
	}
	
	
	// Build IDE
	if (index <= ++indexCheck)
	{
		if (bListCommands) Message1("%d: Compile Windows IDE", indexCheck);
		else
		{
			SetCurrentDirectoryWithCheck("AgkIde");
			int status = 0;
			status = RunCmd(indexCheck, szVisualStudio, "Ide.sln /rebuild \"ReleaseTrial\"");
			if (status != 0) Error("Failed");
			else Message("  Success");
			SetCurrentDirectoryWithCheck("..");

			if (bSingleCommand) goto endPoint;
		}
	}

	// must be done before anything modifies the build folder, otherwise those changes will be overwritten
	if (index <= ++indexCheck)
	{
		if (bListCommands) Message1("%d: Copy IDE files to build folders", indexCheck);
		else
		{
			char msg[128];
			sprintf(msg, "%d: Copying IDE media folder and exe to build folder", indexCheck);
			Message(msg);

			// copy media folder
			char srcFolder[1024];
			strcpy(srcFolder, rootFolder);
			strcat(srcFolder, "\\AgkIde\\media");

			char dstFolder[1024];
			strcpy(dstFolder, szDstFolderWinTrial);
			strcat(dstFolder, "\\media");

			DeleteFolder(dstFolder);
			CopyFolder(srcFolder, dstFolder);

			// copy executable
			strcpy(dstFolder, szDstFolderWinTrial);
			strcat(dstFolder, "\\Ide.exe");
			CopyFile2("AgkIde\\Final\\Ide.exe", dstFolder);

			if (bSingleCommand) goto endPoint;
		}
	}

	// copy to Windows Trial build folder
	if ( index <= ++indexCheck )
	{
		if ( bListCommands ) Message1("%d: Copy files to Windows Trial build folder", indexCheck );
		else
		{

			char msg[128];
			sprintf(msg, "%d: Copying files to Windows Trial build folder", indexCheck);
			Message(msg);

			char srcFolder[ 1024 ];
			char dstFolder[ 1024 ];
			char backupFolder[ 1024 ];
			FileRecord files;

			// copying help files
			Message("    Copying help files");
			strcpy(srcFolder, szSharedFolder); strcat(srcFolder, "\\Studio\\Help");
			strcpy(dstFolder, szDstFolderWinTrial); strcat(dstFolder, "\\media\\Help");
			DeleteFolder(dstFolder);
			CopyFolder(srcFolder, dstFolder);
		
			// copy changelog
			Message("    Copying change log");
			strcpy( dstFolder, szDstFolderWinTrial ); strcat( dstFolder, "\\ChangeLog.txt" );
			CopyFile2( "AGK.txt", dstFolder );

			// copy plugins
			Message("    Copying plugins");
			GetCurrentDirectory( 1024, srcFolder ); strcat( srcFolder, "\\plugins\\Plugins" );
			strcpy( dstFolder, szDstFolderWinTrial ); strcat( dstFolder, "\\Plugins" );
			DeleteFolder( dstFolder );
			CopyFolder( srcFolder, dstFolder );

			// copy interpreter
			Message("    Copying interpreter");
			strcpy( dstFolder, szDstFolderWinTrial ); strcat( dstFolder, "\\media\\interpreters\\Windows64.exe" );
			CopyFile2( "apps\\interpreter\\Final\\Windows64.exe", dstFolder );

			// copy image joiner
			Message("    Copying image joiner");
			strcpy( dstFolder, szDstFolderWinTrial ); strcat( dstFolder, "\\Utilities\\ImageJoiner.exe" );
			CopyFile2( "tools\\ImageJoiner.exe", dstFolder );

			// copying example projects
			Message( "    Copying Example Projects" );
			GetCurrentDirectory( 1024, srcFolder ); strcat( srcFolder, "\\Examples" );
			strcpy( dstFolder, szDstFolderWinTrial ); strcat( dstFolder, "\\media\\Projects" );
			DeleteFolder( dstFolder );
			CopyFolder( srcFolder, dstFolder );

			// delete unnecessary IDE folders
			Message("    Delete Unnecessary IDE folders (android, ios, html5)");
			strcpy(dstFolder, szDstFolderWinTrial); strcat(dstFolder, "\\media\\data\\android");
			DeleteFolder(dstFolder);
			RemoveDirectory(dstFolder);
			strcpy(dstFolder, szDstFolderWinTrial); strcat(dstFolder, "\\media\\data\\ios");
			DeleteFolder(dstFolder);
			RemoveDirectory(dstFolder);
			strcpy(dstFolder, szDstFolderWinTrial); strcat(dstFolder, "\\media\\data\\html5");
			DeleteFolder(dstFolder);
			RemoveDirectory(dstFolder);

			if ( bSingleCommand ) goto endPoint;
		}
	}

	if ( bListCommands ) 
	{
		bListCommands = false;
		goto startPoint;
	}

endPoint:
	system("pause");
	return 0;
}
