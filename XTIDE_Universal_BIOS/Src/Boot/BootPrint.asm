; Project name	:	XTIDE Universal BIOS
; Description	:	Functions for printing boot related strings.

; Section containing code
SECTION .text

;--------------------------------------------------------------------
; BootPrint_TryToBootFromDL
;	Parameters:
;		DL:		Drive to boot from (translated, 00h or 80h)
;		DS:		RAMVARS segment
;	Returns:
;		Nothing
;	Corrupts registers:
;		AX, SI, DI
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
BootPrint_TryToBootFromDL:
	push	bp
	mov		bp, sp

	mov		ax, g_szHDD
	test	dl, dl
	js		SHORT .NotFDD
	mov		ax, g_szFDD
.NotFDD:
	push	ax

	call	DriveXlate_ToOrBack
	push	dx					; Push untranslated drive number
	call	DriveXlate_ToOrBack
	push	dx					; Push translated drive number

	mov		si, g_szTryToBoot
	jmp		BootMenuPrint_FormatCSSIfromParamsInSSBP


;--------------------------------------------------------------------
; BootPrint_BootSectorResultStringFromAX
;	Parameters:
;		CS:AX:	Ptr to "found" or "not found"
;	Returns:
;		Nothing
;	Corrupts registers:
;		AX, CX, SI, DI
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
BootPrint_BootSectorResultStringFromAX:
	push	bp
	mov		bp, sp
	ePUSH_T	cx, g_szBootSector
	push	ax			; "found" or "not found"
	mov		si, g_szSectRead
	jmp		BootMenuPrint_FormatCSSIfromParamsInSSBP


;--------------------------------------------------------------------
; BootPrint_FailedToLoadFirstSector
;	Parameters:
;		AH:		INT 13h error code
;	Returns:
;		Nothing
;	Corrupts registers:
;		AX, CX, SI, DI
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
BootPrint_FailedToLoadFirstSector:
	push	bp
	mov		bp, sp
	eMOVZX	cx, ah
	push	cx					; Push INT 13h error code
	mov		si, g_szReadError
	jmp		BootMenuPrint_FormatCSSIfromParamsInSSBP
