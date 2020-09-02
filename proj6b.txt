;******************************************************************************************
;Program Name: proj6b.asm
;Programmer:   Cameron Weaver
;Class:        CSCI 2160-001
;Date:         December 7, 2019
;Purpose:	   Driver to test external methods within convertMethods
;******************************************************************************************

	.486
	.model flat
	.stack 100h
	
	ExitProcess 		PROTO Near32 stdcall, dwExitCode:dword
	ascint32			PROTO Near32 stdcall, lpStringToConvert:dword 
	intasc32			PROTO Near32 stdcall, lpStringToHold:dword, dval:dword
	getstring			PROTO Near32 stdcall, lpStringToGet:dword, dlength:dword
	putstring 			PROTO Near32 stdcall, lpStringToPrint:dword
	hexToCharacter  	PROTO Near32 stdcall, lpDestination:dword, lpSource:dword, numBytes:dword
	charTo4HexDigits	PROTO Near32 stdCall, lpSourceString:dword
	heapAllocHarrison	PROTO Near32 stdcall, dSize:dword
	encrypt32Bit		PROTO Near32 stdCall, lpSourceString:dword, dMask:dword, numBytes:dword
	String_Length 		PROTO Near32 stdcall, lpString: dword
	.data
;All data identifiers start in cc 1 and the types line up where possible.
strHeading	byte	10,13,10,13,9," Name: Cameron Weaver"
			byte	10,13,9,"Class: CSCI 2160-001"
			byte	10,13,9," Date: December 7, 2019"
			byte	10,13,9,"  Lab: Proj6",10,13,0
strChar 	byte	9	dup (?)						;store user input for mask
sourceStr	byte	100 dup(?)						;Source string for encryption
userStrHex	byte	100 dup(?)						;Stores users string in hex
encryptHex	byte	100 dup(?)						;Stores encrypted string in hex
dEncryptHex	byte	100 dup(?)						;Stores de encrypted string in hex
strChars	byte	10	dup(?)						;Null-terminated string of user chars
maskHex		byte	20	dup(?)						;Contains encryption key in hex
crlf		byte	10,13,0							;null-terminated string that skips to next line
strPrompt	byte	"Enter a 8-hex digit mask",0	
strPrompt1	byte	"Enter a string to be encrypted",0	
strPrompt2	byte	"Users string in Hex:",0	
strPrompt3	byte	"Users encrypted string in Hex:",0	
strPrompt4	byte	"Users de encrypted string in Hex:",0
strPrompt5  byte	"Users Encryption key in Hex:",0	
dMasks		dword	?								;contains dword mask
buffer		dword	?								;buffer between mask and encryption string
addEncrypt 	dword	?								;address of encryption string
deEncrypt 	dword	?								;address of de encrypted string
	.code	
_start: 
	mov eax,-1					;dummy executable statement to aid in debugging.

	main	proc					;beginning of the driver
	INVOKE putstring, ADDR strHeading		;Enter user name
	
;Write your program code	
;  in here

	;Create mask 
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR strPrompt							;Prompt user to enter a 8-hex digit mask 
	INVOKE putstring, ADDR crlf									;line break
	INVOKE getstring, ADDR strChar, 8							;retrieve users 8-hex digit mask, store in strChar
	INVOKE charTo4HexDigits, ADDR strChar						;returns mask in eax
	mov dMasks, eax												;store users mask  
	;Encrypt user string with mask
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR strPrompt1							;Prompt user to enter a string to be encrypted
	INVOKE putstring, ADDR crlf									;line break
	INVOKE getstring, ADDR sourceStr, 101						;Retrieve string to be encrypted from user
	INVOKE String_length, ADDR sourceStr						;returns number of bytes in eax 
	INVOKE encrypt32Bit, ADDR sourceStr, dMasks, eax			;returns address of encrypted string
	mov addEncrypt, eax											;addEncrypt contains address of encrypted string
	;Store and display encryption key hex values 
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR crlf									;line break 
	INVOKE putstring, ADDR strPrompt5							;Prompt user "Users Encryption key in Hex:"
	INVOKE hexToCharacter, ADDR maskHex, dMasks, 0				;encryption key ASCII values returned in maskHex
	mov eax, 0													;reset eax to 0 to avoid corrupting invoke
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR maskHex								;Display encryption key back to user
	;Converts and displays user string in hex
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR strPrompt2							;Prompt user "Users string in Hex:"
	INVOKE String_length, ADDR sourceStr						;returns number of bytes in eax
	INVOKE hexToCharacter, ADDR userStrHex, ADDR sourceStr, eax;Convert users string to show hex values
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR userStrHex							;Display users string in hex hev values
	;Converts and displays user encrypted string in hex
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR strPrompt3							;Prompt user "Users encrypted string in Hex:"
	INVOKE String_Length, addEncrypt							;Obtain length of encrypted string
	INVOKE hexToCharacter, ADDR encryptHex, addEncrypt, eax		;return hex values of encrypted string
	INVOKE putstring, ADDR crlf									;line break6
	INVOKE putstring, ADDR  encryptHex							;Display hex values of encrypted string
	;de encrypts user string
	INVOKE String_length, addEncrypt							;returns number of bytes in eax 
	INVOKE encrypt32Bit, addEncrypt, dMasks, eax				;returns address of encrypted string in eax
	mov deEncrypt, eax 											;deEncrypt -> address of de encrypted string
	mov eax, 0													;set eax to 0 to avoid errors in invoke
	;Converts and displays user's de encrypted string in hex
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR strPrompt4							;Prompt user "Users encrypted string in Hex:"
	INVOKE String_length, deEncrypt								;returns number of bytes in eax
	INVOKE hexToCharacter, ADDR dEncryptHex, deEncrypt, eax		;Convert de encrypted string to show hex values
	INVOKE putstring, ADDR crlf									;line break
	INVOKE putstring, ADDR dEncryptHex							;Display users de encrypted string in hex hev values
	
	INVOKE ExitProcess,0				;terminate "normally" the program
main	endp							;end of the "driving program"
	PUBLIC _start
;any PROCs that you will add later go in here	

	END								;The very LAST line in your program. Terminate assembly
	