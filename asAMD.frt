
 ASSEMBLER DEFINITIONS HEX

0000 00 0000 T!

\ Extensions for 64 bits. N is normal, P is primed, I is the SIB-index
\ Extensions for 64 bits. B is normal, R is primed, X is the SIB-index
\ THe modRM reg field is the extra register, i.e. the primed one.
\ E is extended registers, Q is 64 bits and maybe extended registers.
\ The rule : ' applies to AX'| and ] applies to AX] while N applies to others.
\ 01 48 8 1FAMILY, Q: QB: QX: QXB: QR: QRB: QRX: QRXB:
01 48 8 1FAMILY, Q: QN: Q]: QN]: Q': QN': Q']: QN']:
01 40 8 1FAMILY, E: EN: E]: EN]: E': EN': E']: EN']:
PREVIOUS DEFINITIONS DECIMAL
