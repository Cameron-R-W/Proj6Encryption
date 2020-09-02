;******************************************************************************************
;Program Name: convertMethods.asm
;Programmer:   Cameron Weaver
;Class:        CSCI 2160-001
;Date:         December 07, 2019 at 12:00 PM
;Purpose:	   Class that will contains methods for hex to char, char to hex, and encryption
;	
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
	
	
	.code
	
COMMENT %
;*****************************************************************************************
;* Name:  charTo4HexDigits																 *
;* Purpose:	Accepts a string returns dword mask  										 *
;*																						 *
;* Date created: November 17, 2019														 *	 
;* Date last modified: November 29, 2018												 *	 				 
;*																						 *
;* Notes:	None																		 *
;*																						 *
;*	@param lpSourceString:dword														 	 *
;*	@return dword														 				 *			
;*****************************************************************************************%	
charTo4HexDigits proc stdCall uses ebx edx esi, lpSourceString:dword
	local firstByte:dword, secondByte:dword
	mov ebx, lpSourceString					;ebx -> lpSourceString
	mov esi, 0								;esi used to increment through lpSourceString				
	mov eax, 0								;eax used to store bytes and make comparisons
	mov edx, 0								;edx will store the mask
	;Check first two bytes
	mov al, [ebx + esi]						;grab first byte from lpSourceString for comparison
	.if eax  > 40h && eax < 47h 			;compare first byte between A - F
		sub al, 55							;subtract 55 decimal value to return a-f decimal 
	.endif									;finish checking for A - F
	.if eax > 60h && eax < 67h				;compare first byte between a - f
		sub al, 87							;subtract 75 decimal value to return a-f decimal
	.endif									;finish checking for a - f
	.if eax < 40h && eax > 29h				;compare first byte between 0 - 9
		sub al, 48							;subtract 48 decimal value to return 0-9 decimal
	.endif									;finish checking for 0 - 9
	inc esi									;increment esi to point to next byte in lpSourceString
	mov firstByte, eax						;store first byte to later multiply 
	mov al, [ebx + esi]						;grab first byte from lpSourceString for comparison
	.if eax  > 40h && eax < 47h 			;compare first byte between A - F
		sub al, 55							;subtract 55 decimal value to return a-f decimal 
	.endif									;finish checking for A - F
	.if eax > 60h && eax < 67h				;compare first byte between a - f
		sub al, 87							;subtract 75 decimal value to return a-f decimal
	.endif									;finish checking for a - f
	.if eax < 40h && eax > 29h				;compare first byte between 0 - 9
		sub al, 48							;subtract 48 decimal value to return 0-9 decimal
	.endif									;finish checking for 0 - 9
	inc esi									;increment esi to point to next byte in lpSourceString
	mov secondByte, eax						;store second byte to later add
	;Multiply and add 1st & 2nd byte
	mov eax, firstByte						;store first byte to multiply by 16
	imul eax, 16							;multiply first byte to return decimal value
	add eax, secondByte						;add secondByte to return decimal value of firstByte + secondByte
	mov dl, al 								;store byte in edx to rotate
	shl edx, 8								;shift result left to store result 
	;Check bytes 3 - 4
	mov eax, 0								;eax used to store bytes and make comparisons
	mov al, [ebx + esi]						;grab third byte from lpSourceString for comparison
	.if eax  > 40h && eax < 47h 			;compare third byte between A - F
		sub al, 55							;subtract 55 decimal value to return a-f decimal 
	.endif									;finish checking for A - F
	.if eax > 60h && eax < 67h				;compare third byte between a - f
		sub al, 87							;subtract 75 decimal value to return a-f decimal
	.endif									;finish checking for a - f
	.if eax < 40h && eax > 29h				;compare third byte between 0 - 9
		sub al, 48							;subtract 48 decimal value to return 0-9 decimal
	.endif									;finish checking for 0 - 9
	inc esi									;increment esi to point to next byte in lpSourceString
	mov firstByte, eax						;store third byte to later multiply 
	mov al, [ebx + esi]						;grab first byte from lpSourceString for comparison
	.if eax  > 40h && eax < 47h 			;compare fourth byte between A - F
		sub al, 55							;subtract 55 decimal value to return a-f decimal 
	.endif									;finish checking for A - F
	.if eax > 60h && eax < 67h				;compare fourth byte between a - f
		sub al, 87							;subtract 75 decimal value to return a-f decimal
	.endif									;finish checking for a - f
	.if eax < 40h && eax > 29h				;compare fourth byte between 0 - 9
		sub al, 48							;subtract 48 decimal value to return 0-9 decimal
	.endif									;finish checking for 0 - 9
	inc esi									;increment esi to point to next byte in lpSourceString
	mov secondByte, eax						;store fourth byte to later add
	;Multiply and add 3rd & 4th byte
	mov eax, firstByte						;store  3rd byte to multiply by 16
	imul eax, 16							;multiply 3rd byte to return decimal value
	add eax, secondByte						;add secondByte to return decimal value of firstByte + secondByte
	mov dl, al 								;store byte in edx to rotate
	shl edx, 8								;shift result left to store result 
	;Check bytes 5 - 6
	mov eax, 0								;eax used to store bytes and make comparisons
	mov al, [ebx + esi]						;grab 5th byte from lpSourceString for comparison
	.if eax  > 40h && eax < 47h 			;compare 5th byte between A - F
		sub al, 55							;subtract 55 decimal value to return a-f decimal 
	.endif									;finish checking for A - F
	.if eax > 60h && eax < 67h				;compare fifth byte between a - f
		sub al, 87							;subtract 75 decimal value to return a-f decimal
	.endif									;finish checking for a - f
	.if eax < 40h && eax > 29h				;compare fifth byte between 0 - 9
		sub al, 48							;subtract 48 decimal value to return 0-9 decimal
	.endif									;finish checking for 0 - 9
	inc esi									;increment esi to point to next byte in lpSourceString
	mov firstByte, eax						;store fifth byte to later multiply 
	mov al, [ebx + esi]						;grab 6th byte from lpSourceString for comparison
	.if eax  > 40h && eax < 47h 			;compare 6th byte between A - F
		sub al, 55							;subtract 55 decimal value to return a-f decimal 
	.endif									;finish checking for A - F
	.if eax > 60h && eax < 67h				;compare 6th byte between a - f
		sub al, 87							;subtract 75 decimal value to return a-f decimal
	.endif									;finish checking for a - f
	.if eax < 40h && eax > 29h				;compare 6th byte between 0 - 9
		sub al, 48							;subtract 48 decimal value to return 0-9 decimal
	.endif									;finish checking for 0 - 9
	inc esi									;increment esi to point to next byte in lpSourceString
	mov secondByte, eax						;store 6th byte to later add
	;Multiply and add 5th & 6th byte
	mov eax, firstByte						;store 5th byte to multiply by 16
	imul eax, 16							;multiply 5th byte to return decimal value
	add eax, secondByte						;add secondByte to return decimal value of firstByte + secondByte
	mov dl, al 								;store byte in edx to rotate
	shl edx, 8								;shift result left to store result 
	;Check bytes 7 - 8
	mov eax, 0								;eax used to store bytes and make comparisons
	mov al, [ebx + esi]						;grab 7th byte from lpSourceString for comparison
	.if eax  > 40h && eax < 47h 			;compare 7th byte between A - F
		sub al, 55							;subtract 55 decimal value to return a-f decimal 
	.endif									;finish checking for A - F
	.if eax > 60h && eax < 67h				;compare 7th byte between a - f
		sub al, 87							;subtract 75 decimal value to return a-f decimal
	.endif									;finish checking for a - f
	.if eax < 40h && eax > 29h				;compare 7th byte between 0 - 9
		sub al, 48							;subtract 48 decimal value to return 0-9 decimal
	.endif									;finish checking for 0 - 9
	inc esi									;increment esi to point to next byte in lpSourceString
	mov firstByte, eax						;store 7th byte to later multiply 
	mov al, [ebx + esi]						;grab 8th byte from lpSourceString for comparison
	.if eax  > 40h && eax < 47h 			;compare 8th byte between A - F
		sub al, 55							;subtract 55 decimal value to return a-f decimal 
	.endif									;finish checking for A - F
	.if eax > 60h && eax < 67h				;compare 8th byte between a - f
		sub al, 87							;subtract 75 decimal value to return a-f decimal
	.endif									;finish checking for a - f
	.if eax < 40h && eax > 29h				;compare 8th byte between 0 - 9
		sub al, 48							;subtract 48 decimal value to return 0-9 decimal
	.endif									;finish checking for 0 - 9
	inc esi									;increment esi to point to next byte in lpSourceString
	mov secondByte, eax						;store 8th byte to later add
	;Multiply and add 6th & 8th byte
	mov eax, firstByte						;store 7th byte to multiply by 16
	imul eax, 16							;multiply first byte to return decimal value
	add eax, secondByte						;add secondByte to return decimal value of firstByte + secondByte
	mov dl, al 								;store byte in edx to rotate
	mov eax, edx							;return dword mask (eax)
	RET										;return to driver
charTo4HexDigits endp	
	;*************************************************************************************
;* Name:  encrypt32Bit																 	 *
;* Purpose:	Encrypt a null-terminated string of characters using a 32-bit mask key 		 *
;*																						 *
;* Date created: November 17, 2019														 *	 
;* Date last modified: November 29, 2018												 *	 				 
;*																						 *
;* Notes:	rmdr will contain remaining number of bytes left in lpSource (1 - 3) bytes	 *
;*																						 *
;*	@param lpSourceString:dword, dMask:dword, numBytes:dword							 *
;*	@return dword														 				 *			
;*****************************************************************************************%	
encrypt32Bit proc stdCall uses ebx ecx edx esi, lpSourceString:dword, dMask:dword, numBytes:dword
	local rmdr:dword
	mov eax, numBytes				;eax used to create amount of bytes in heap
	inc eax 						;inc eax to add null value
	mov ebx, eax					;store numBytes needed in ebx to use with invoke
	INVOKE heapAllocHarrison, ebx	;Create heap to store encrypted string
	mov ebx, lpSourceString			;ebx -> lpSourceString
	mov edx, numBytes				;edx used to subtract 4 from numBytes
	mov ecx, 0						;ecx tracks x times we can take 4 bytes from lpSource
	mov esi, 0						;esi used to increment through lpSourceString
subNumBytes:						;keep subtracting 4 from numBytes till numBytes < 4
	sub edx, 4						;sub 4 from numBytes(edx) till numBytes < 4
	inc ecx							;increment ecx to track x amount can subtract numBytes by 4
	cmp edx, 4						;if numBytes(edx) is less than 4 set the remainder
	jl setRemainder					;jump to set the remainder of bytes remaining in numBytes(edx)
	jmp subNumBytes					;repeat till numBytes(edx) < 4
setRemainder:						;set rmdr the remaining of bytes left in numBytes(edx)
	mov rmdr, edx					;rmdr, amount of bytes remaining after dividing by 4
	mov edx, 0						;edx used to xor with dMask
loopSource:							;loop through source string amount divisible by 4(ecx)
	mov dl, [ebx + esi]				;grab 1st byte of 4 from lpSourceString
	shl edx, 8 						;shift left to make room for the 3 other bytes
	inc esi							;inc esi to point to 2nd byte
	mov dl, [ebx + esi]				;grab 2nd byte of 4 from lpSourceString
	shl edx, 8 						;shift left to make room for the 2 other bytes
	inc esi							;inc esi to point to 3rd byte
	mov dl, [ebx + esi]				;grab 3rd byte of 4 from lpSourceString
	shl edx, 8 						;shift left to make room for the 1 other bytes
	inc esi							;inc esi to point to 4th byte
	mov dl, [ebx + esi]				;grab 4th byte of 4 from lpSourceString
	xor edx, dMask					;xor to encrypt the 4 bytes
	sub esi, 3						;sub 3 from esi to store into heap(eax)
	rol edx, 8						;rotate highest order byte to lowest to move into heap 
	mov [eax + esi], dl 			;move lowest order into heap
	inc esi							;increase esi to point to next byte in the heap
	rol edx, 8						;rotate highest order byte to lowest to move into heap 
	mov [eax + esi], dl 			;move lowest order into heap
	inc esi							;increase esi to point to next byte in the heap
	rol edx, 8						;rotate highest order byte to lowest to move into heap 
	mov [eax + esi], dl 			;move lowest order into heap
	inc esi							;increase esi to point to next byte in the heap
	rol edx, 8						;rotate highest order byte to lowest to move into heap 
	mov [eax + esi], dl 			;move lowest order into heap
	inc esi							;increase esi to point to next byte in the heap
loop loopSource						;repeat loop until 4x bytes have been xor'd
	mov ecx, rmdr 					;store remaining number of bytes in ecx for comparison
	mov edx, 0						;reset edx to 0 for reuse
	.if ecx == 1					;if number of bytes remaining = 1 mask only 1 byte
		mov dl, [ebx + esi]			;grab last remaining byte from lpSource
		mov ecx, dMask				;set ecx to dMask to grab highest order byte to mask
		rol ecx, 8					;rotate highest order 
		xor dl, cl					;encrypt byte with lowest order
		mov [eax + esi], dl			;store encrypted byte in heap
		inc esi						;increase esi to point to next byte
		mov byte ptr [eax + esi], 0	;store null value
	.endif							;check if num bytes remaining = 2
	.if ecx == 2					;if number of bytes remaining = 2 mask only 2 bytes
		mov dl, [ebx + esi]			;grab 1st byte of last 2 bytes from lpSource
		shl edx, 8					;shift left to store 2nd byte in dl
		inc esi						;increment esi to point to next byte
		mov dl, [ebx + esi]			;grab 2nd byte of last 2 bytes from lpSource
		mov ecx, dMask				;set ecx to dMask to grab highest order byte to mask
		rol ecx, 16					;rotate 2 bytes from the left, mask = cx
		xor dx, cx 					;encrypt byte with two lowest order cx
		rol edx, 24					;rotate so lowest order is first byte to move into heap
		dec esi						;decrement esi to point to correct place in heap
		mov [eax + esi], dl			;place lowest order encrypted byte (dl) into heap
		inc esi						;increment esi to point to next byte
		rol edx, 8					;rotate edx, lowest order is next encrypted byte to store to heap
		mov [eax + esi], dl			;place lowest order encrypted byte (dl) into heap
		inc esi						;increase esi to point to next byte
		mov byte ptr [eax + esi], 0	;store null value
	.endif							;check if num bytes remaining = 3
	.if ecx == 3					;if number of bytes remaining = 3 mask only 3 bytes
		mov dl, [ebx + esi]			;grab 1st byte of last 3 bytes from lpSource
		shl edx, 8					;shift left to store 2nd byte in dl
		inc esi						;increment esi to point to next byte
		mov dl, [ebx + esi]			;grab 2nd byte of last 3 bytes from lpSource
		shl edx, 8					;shift left to store 3rd byte in dl
		inc esi						;increment esi to point to next byte
		mov dl, [ebx + esi]			;grab 3rd byte of last 3 bytes from lpSource
		mov ecx, dMask				;set ecx to dMask to mask last 3 bytes
		rol ecx, 24					;rotate mask 3 bytes to correlate with edx
		shl ecx, 8					;get rid of highest order byte
		shr ecx, 8					;set highest order byte to 0
		xor edx, ecx				;mask the last 3 bytes of lpSource
		sub esi, 2					;subtract esi by 2 to point to correct position of lpSource
		rol edx, 16					;rotate edx so first byte is in lowest order(dl)
		mov [eax + esi], dl 		;place lowest order encrypted byte 1 (dl) into heap
		inc esi						;increment esi to point to next byte
		rol edx, 8					;rotate edx so second byte is in lowest order (dl)
		mov [eax + esi], dl			;place lowest order encrypted byte 2 (dl) into heap 
		inc esi						;increment esi to point to next byte
		rol edx, 8					;rotate edx so third byte is in lowest order (dl)
		mov [eax + esi], dl			;place lowest order encrypted byte 3 (dl) into heap
		inc esi						;increase esi to point to next byte
		mov byte ptr [eax + esi], 0	;store null value	
	.endif							;check if num bytes remaining = 0
	.if ecx == 0					;if number of bytes remaining = 0 set null value
		mov byte ptr [eax + esi], 0	;set null value of heap
	.endif							;end if statement
	RET
encrypt32Bit endp
COMMENT %
;******************************************************************************************
;* Name: String_length																	  *												
;* Purpose: Accepts a string and returns the number of non-null characters			      *
;*																						  *
;* Date created: October 15, 2019														  *
;* Date last modified: October 15, 2019													  *
;*																						  *
;* Notes on specifications, special algorithms, and assumptions:						  *
;*																						  *
;*																						  *
;*																						  *
;*	@param 	lpString:dword													              *
;*	@return	dword																	  	  *
;****
%
String_Length proc stdcall uses edx esi, lpString: dword
	mov edx, lpString 				;edx -> lpString
	mov esi, 0						;esi will itterate through the string
stLoop:								;Loop through string till null term is reached
	cmp byte ptr [edx + esi], 0		;Checking for null terminator
	je finish						;if null found then reached end of string. ESI = LENGTH
	inc esi							;keep incrementing esi till null is reached
	jmp stLoop						;Repeat until null value found
finish:								;when finish return eax(length of string)
	mov eax, esi					;eax -> length of string
	RET								;return to driver
String_Length endp					;end of String_Length
;*****************************************************************************************
;* Name:  hexToCharacter																 *
;* Purpose:	Accepts a users string and returns a printable string of its hex values  	 *
;*																						 *
;* Date created: November 17, 2019														 *	 
;* Date last modified: November 29, 2018												 *	 				 
;*																						 *
;* Notes:	None																		 *
;*																						 *
;*	@param lpDestination:dword, lpSource:dword, numBytes:dword							 *
;*	@return dword														 				*			
;*****************************************************************************************%	
hexToCharacter proc stdCall uses ebx ecx edx esi, lpDestination:dword, lpSource:dword, numBytes:dword
	local lpDest:dword, lpSc:dword	
	mov ecx, numBytes						;ecx used to check if numBytes = 0
	.if ecx == 0							;check if lpSource is a dword
		mov eax, lpDestination				;eax -> lpDestination
		mov esi, 0							;esi used to increment through lpDestination
		mov edx, 0							;edx used to convert bytes
		mov ebx, lpSource					;ebx -> lpSource
	;1st byte of lpSource
		rol ebx, 8							;place highest order byte in lowest order
		mov dl, bl							;place lowest byte in dl to isolate lowest order byte
		ror edx, 4							;separate the first bit in dl from the 2nd bit 
		.if dl < 10							;if first bit is less than 10 then can add by 30h
			add dl, 30h						;add 30h to set decimal value of bit in ASCII
			mov [eax + esi], dl				;store first byte(Hex of first bit) in lpDestination
			mov dl, 0						;clear lowest order byte
			inc esi							;increment esi to point to next byte
		.endif								;byte is not 0 - 9
		.if dl >= 10						;check if bit is A - F
			add dl, 37h						;add 31h to bit to return hex value of A - F
			mov [eax + esi], dl				;store hex value of bit in lpDestination
			mov dl, 0						;clear lowest order byte
			inc esi							;increment esi to point to next byte
		.endif								;check 2nd bit of 1st byte
		rol edx, 4 							;shift 2nd bit to lowest order 
		.if dl < 10							;if first bit is less than 10 then can add by 30h
			add dl, 30h						;add 30h to set decimal value of bit in ASCII
			mov [eax + esi], dl				;store first byte(Hex of first bit) in lpDestination
			mov dl, 0						;clear lowest order byte
			inc esi							;increment esi to point to next byte
		.endif								;byte is not 0 - 9
		.if dl >= 10						;check if bit is A - F
			add dl, 37h						;add 31h to bit to return hex value of A - F
			mov [eax + esi], dl				;store hex value of bit in lpDestination
			inc esi							;increment esi to point to next byte
		.endif								;check 2nd bit of 1st byte
	;2nd byte of lpSource
		rol ebx, 8							;grab next byte from dword lpSource
		mov dl, bl 							;place lowest byte in dl to isolate lowest order byte
		ror edx, 4							;separate the first bit in dl from the 2nd bit 
		.if dl < 10							;if first bit is less than 10 then can add by 30h
			add dl, 30h						;add 30h to set decimal value of bit in ASCII
			mov [eax + esi], dl				;store first byte(Hex of first bit) in lpDestination
			mov dl, 0						;clear lowest order byte
			inc esi							;increment esi to point to next byte
		.endif								;byte is not 0 - 9
		.if dl >= 10						;check if bit is A - F
			add dl, 37h						;add 31h to bit to return hex value of A - F
			mov [eax + esi], dl				;store hex value of bit in lpDestination
			mov dl, 0						;clear lowest order byte
			inc esi							;increment esi to point to next byte
		.endif								;check 2nd bit of 1st byte
		rol edx, 4 							;shift 2nd bit to lowest order 
		.if dl < 10							;if first bit is less than 10 then can add by 30h
			add dl, 30h						;add 30h to set decimal value of bit in ASCII
			mov [eax + esi], dl				;store first byte(Hex of first bit) in lpDestination
			mov dl, 0						;clear lowest order byte
			inc esi							;increment esi to point to next byte
		.endif								;byte is not 0 - 9
		.if dl >= 10						;check if bit is A - F
			add dl, 37h						;add 31h to bit to return hex value of A - F
			mov [eax + esi], dl				;store hex value of bit in lpDestination
			inc esi							;increment esi to point to next byte
		.endif								;check 2nd bit of 1st byte
	;3rd byte of lpSource
		rol ebx, 8							;grab next byte from dword lpSource
		mov dl, bl 							;place lowest byte in dl to isolate lowest order byte
		ror edx, 4							;separate the first bit in dl from the 2nd bit 
		.if dl < 10							;if first bit is less than 10 then can add by 30h
			add dl, 30h						;add 30h to set decimal value of bit in ASCII
			mov [eax + esi], dl				;store first byte(Hex of first bit) in lpDestination
			mov dl, 0
			inc esi							;increment esi to point to next byte
		.endif								;byte is not 0 - 9
		.if dl >= 10						;check if bit is A - F
			add dl, 37h						;add 31h to bit to return hex value of A - F
			mov [eax + esi], dl				;store hex value of bit in lpDestination
			mov dl, 0
			inc esi							;increment esi to point to next byte
		.endif								;check 2nd bit of 1st byte
		rol edx, 4	 						;shift 2nd bit to lowest order 
		.if dl < 10							;if first bit is less than 10 then can add by 30h
			add dl, 30h						;add 30h to set decimal value of bit in ASCII
			mov [eax + esi], dl				;store first byte(Hex of first bit) in lpDestination
			mov dl, 0						;clear lowest order byte
			inc esi							;increment esi to point to next byte
		.endif								;byte is not 0 - 9
		.if dl >= 10						;check if bit is A - F
			add dl, 37h						;add 31h to bit to return hex value of A - F
			mov [eax + esi], dl				;store hex value of bit in lpDestination
			inc esi							;increment esi to point to next byte
		.endif								;check 2nd bit of 1st byte
	;4th byte of lpSource
		rol ebx, 8							;grab next byte from dword lpSource
		mov dl, bl 							;place lowest byte in dl to isolate lowest order byte
		ror edx, 4							;separate the first bit in dl from the 2nd bit 
		.if dl < 10							;if first bit is less than 10 then can add by 30h
			add dl, 30h						;add 30h to set decimal value of bit in ASCII
			mov [eax + esi], dl				;store first byte(Hex of first bit) in lpDestination
			mov dl, 0
			inc esi							;increment esi to point to next byte
		.endif								;byte is not 0 - 9
		.if dl >= 10						;check if bit is A - F
			add dl, 37h						;add 31h to bit to return hex value of A - F
			mov [eax + esi], dl				;store hex value of bit in lpDestination
			mov dl, 0
			inc esi							;increment esi to point to next byte
		.endif								;check 2nd bit of 1st byte
		rol edx, 4 							;shift 2nd bit to lowest order 
		.if dl < 10							;if first bit is less than 10 then can add by 30h
			add dl, 30h						;add 30h to set decimal value of bit in ASCII
			mov [eax + esi], dl				;store first byte(Hex of first bit) in lpDestination
			mov dl, 0						;clear lowest order byte
			inc esi							;increment esi to point to next byte
		.endif								;byte is not 0 - 9
		.if dl >= 10						;check if bit is A - F
			add dl, 37h						;add 31h to bit to return hex value of A - F
			mov [eax + esi], dl				;store hex value of bit in lpDestination	
			inc esi							;increment esi to point to next byte
		.endif								;check 2nd bit of 1st byte
	.endif									;return to driver
	cmp ecx, 0								;if numbytes(ecx) = 0
	je returnDword	 						;exit method return to driver
	mov esi, 0								;esi used to increment through lpSource
	mov lpDest, 0							;lpDest used to increment through lpDestination
	mov ecx, numBytes						;ecx used to loop the # of bytes
	mov ebx, lpSource						;ebx -> lpSource
	mov eax, lpDestination					;eax -> lpDestination
	mov lpDest, 0							;lpDest used to increment through lpDestination
nextBytes:									;loop through each byte of lpSource
	cmp ecx, 0								;if ecx < 0 gone through each byte finish 
	jle finish								;if ecx = 0, finish method return 
	mov edx, 0								;set edx to 0 to store bytes 
	mov dl, [ebx + esi]						;grab byte from lpSource
	inc esi									;increment esi to point to next byte in lpSource
	ror edx,4								;rotate bit to the right to isolate 1st bit in dl
	.if dl == 0								;if bit = 0, place 30h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 30h		;store '0' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 1								;if bit = 1, place 31h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 31h		;store '1' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 2								;if bit = 2, place 32h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 32h		;store '2' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 3								;if bit = 3, place 33h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 33h		;store '3' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 4								;if bit = 4, place 34h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 34h		;store '4' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 5								;if bit = 5, place 35h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 35h		;store '5' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 6								;if bit = 6, place 36h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 36h		;store '6' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 7								;if bit = 7, place 37h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 37h		;store '7' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 8								;if bit = 8, place 38h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 38h		;store '8' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 9								;if bit = 9, place 34h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 39h		;store '9' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 10							;if bit = 10(A), place 41h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 41h		;store 'A' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 11							;if bit = 11(B), place 42h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 42h		;store 'B' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 12							;if bit = 12(C), place 43h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 43h		;store 'C' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 13							;if bit = 13(D), place 44h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 44h		;store 'D' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 14							;if bit = 14(E), place 45h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 45h		;store 'E' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 15							;if bit = 15(B), place 46h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 46h		;store 'F' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	rol edx, 4								;place 2nd bit back with 1st bit in lowest order
	shl edx, 24								;swap lowest order with highest order to delete 1st bit
	shl edx, 4								;delete 1st bit in highest order
	rol edx, 4								;place 2nd bit back(isolated) back in lowested order(dl)
		.if dl == 0							;if bit = 0, place 30h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 30h		;store '0' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 1								;if bit = 1, place 31h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 31h		;store '1' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 2								;if bit = 2, place 32h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 32h		;store '2' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 3								;if bit = 3, place 33h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 33h		;store '3' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 4								;if bit = 4, place 34h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 34h		;store '4' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 5								;if bit = 5, place 35h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 35h		;store '5' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 6								;if bit = 6, place 36h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 36h		;store '6' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 7								;if bit = 7, place 37h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 37h		;store '7' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 8								;if bit = 8, place 38h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 38h		;store '8' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 9								;if bit = 9, place 34h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 39h		;store '9' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 10							;if bit = 10(A), place 41h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 41h		;store 'A' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 11							;if bit = 11(B), place 42h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 42h		;store 'B' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 12							;if bit = 12(C), place 43h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 43h		;store 'C' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 13							;if bit = 13(D), place 44h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 44h		;store 'D' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 14							;if bit = 14(E), place 45h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 45h		;store 'E' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	.if dl == 15							;if bit = 15(B), place 46h into lpDestination
		mov lpSc, esi						;store lpSourceStrings increment to re use esi
		mov esi, lpDest						;esi use to indiciate which byte in lpDestination
		mov byte ptr [eax + esi], 46h		;store 'F' into lpDestination
		add esi, 1							;add 1 to lpDest to point to next byte in lpDestination
		mov lpDest, esi						;free up esi by storing lpDestination increment into lpDest
		mov esi, lpSc						;restore esi to point to byte in lpSourceString
	.endif 									;check dl for next bit
	dec ecx									;decrement ecx to track numBytes
	cmp ecx, 0								;if ecx = 0, gone through each byte
	jg	nextBytes							;if not 0 check next byte of lpSource
finish:										;store 2x 30h to signify null value
	mov esi, lpDest							;esi points to next byte in lpDestination
	mov byte ptr [eax + esi], 30h			;store '0' into lpDestination
	inc esi									;increment esi to point to next byte in lpDestination
	mov byte ptr [eax + esi], 30h			;store '0' into lpDestination
	inc esi									;increment esi to point to next byte in lpDestination
	mov byte ptr [eax + esi], 0				;store null value into lpDestination
returnDword:
	RET										;return to driver
hexToCharacter endp 
	END