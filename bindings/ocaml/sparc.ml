(* Capstone Disassembler Engine
 * By Guillaume Jeanne <guillaume.jeanne@ensimag.fr>, 2014> *)

type sparc_op_mem = {
	base: int;
	index: int;
	displ: int;
}

type sparc_op = 
	| SPARC_OP_INVALID of int
	| SPARC_OP_REG of int
	| SPARC_OP_IMM of int
	| SPARC_OP_MEM of sparc_op_mem

type cs_sparc = { 
	cc: int;
	hint: int;
	op_count: int;
	operands: sparc_op array;
}

(*  Enums corresponding to Sparc condition codes, both icc's and fcc's. *)

let _SPARC_CC_INVALID = 0;;

(*  Integer condition codes *)
let _SPARC_CC_ICC_A = 8+256;;
let _SPARC_CC_ICC_N = 0+256;;
let _SPARC_CC_ICC_NE = 9+256;;
let _SPARC_CC_ICC_E = 1+256;;
let _SPARC_CC_ICC_G = 10+256;;
let _SPARC_CC_ICC_LE = 2+256;;
let _SPARC_CC_ICC_GE = 11+256;;
let _SPARC_CC_ICC_L = 3+256;;
let _SPARC_CC_ICC_GU = 12+256;;
let _SPARC_CC_ICC_LEU = 4+256;;
let _SPARC_CC_ICC_CC = 13+256;;
let _SPARC_CC_ICC_CS = 5+256;;
let _SPARC_CC_ICC_POS = 14+256;;
let _SPARC_CC_ICC_NEG = 6+256;;
let _SPARC_CC_ICC_VC = 15+256;;
let _SPARC_CC_ICC_VS = 7+256;;

(*  Floating condition codes *)
let _SPARC_CC_FCC_A = 8+16+256;;
let _SPARC_CC_FCC_N = 0+16+256;;
let _SPARC_CC_FCC_U = 7+16+256;;
let _SPARC_CC_FCC_G = 6+16+256;;
let _SPARC_CC_FCC_UG = 5+16+256;;
let _SPARC_CC_FCC_L = 4+16+256;;
let _SPARC_CC_FCC_UL = 3+16+256;;
let _SPARC_CC_FCC_LG = 2+16+256;;
let _SPARC_CC_FCC_NE = 1+16+256;;
let _SPARC_CC_FCC_E = 9+16+256;;
let _SPARC_CC_FCC_UE = 10+16+256;;
let _SPARC_CC_FCC_GE = 11+16+256;;
let _SPARC_CC_FCC_UGE = 12+16+256;;
let _SPARC_CC_FCC_LE = 13+16+256;;
let _SPARC_CC_FCC_ULE = 14+16+256;;
let _SPARC_CC_FCC_O = 15+16+256;;

(*  Branch hint *)
let _SPARC_HINT_INVALID = 0;;
let _SPARC_HINT_A = 1 lsl 0;;
let _SPARC_HINT_PT = 1 lsl 1;;
let _SPARC_HINT_PN = 1 lsl 2;;

(*  Operand type for instruction's operands *)

let _SPARC_OP_INVALID = 0;;
let _SPARC_OP_REG = 1;;
let _SPARC_OP_IMM = 2;;
let _SPARC_OP_MEM = 3;;

(*  SPARC registers *)

let _SPARC_REG_INVALID = 0;;
let _SPARC_REG_F0 = 1;;
let _SPARC_REG_F1 = 2;;
let _SPARC_REG_F2 = 3;;
let _SPARC_REG_F3 = 4;;
let _SPARC_REG_F4 = 5;;
let _SPARC_REG_F5 = 6;;
let _SPARC_REG_F6 = 7;;
let _SPARC_REG_F7 = 8;;
let _SPARC_REG_F8 = 9;;
let _SPARC_REG_F9 = 10;;
let _SPARC_REG_F10 = 11;;
let _SPARC_REG_F11 = 12;;
let _SPARC_REG_F12 = 13;;
let _SPARC_REG_F13 = 14;;
let _SPARC_REG_F14 = 15;;
let _SPARC_REG_F15 = 16;;
let _SPARC_REG_F16 = 17;;
let _SPARC_REG_F17 = 18;;
let _SPARC_REG_F18 = 19;;
let _SPARC_REG_F19 = 20;;
let _SPARC_REG_F20 = 21;;
let _SPARC_REG_F21 = 22;;
let _SPARC_REG_F22 = 23;;
let _SPARC_REG_F23 = 24;;
let _SPARC_REG_F24 = 25;;
let _SPARC_REG_F25 = 26;;
let _SPARC_REG_F26 = 27;;
let _SPARC_REG_F27 = 28;;
let _SPARC_REG_F28 = 29;;
let _SPARC_REG_F29 = 30;;
let _SPARC_REG_F30 = 31;;
let _SPARC_REG_F31 = 32;;
let _SPARC_REG_F32 = 33;;
let _SPARC_REG_F34 = 34;;
let _SPARC_REG_F36 = 35;;
let _SPARC_REG_F38 = 36;;
let _SPARC_REG_F40 = 37;;
let _SPARC_REG_F42 = 38;;
let _SPARC_REG_F44 = 39;;
let _SPARC_REG_F46 = 40;;
let _SPARC_REG_F48 = 41;;
let _SPARC_REG_F50 = 42;;
let _SPARC_REG_F52 = 43;;
let _SPARC_REG_F54 = 44;;
let _SPARC_REG_F56 = 45;;
let _SPARC_REG_F58 = 46;;
let _SPARC_REG_F60 = 47;;
let _SPARC_REG_F62 = 48;;
let _SPARC_REG_FCC0 = 49;;
let _SPARC_REG_FCC1 = 50;;
let _SPARC_REG_FCC2 = 51;;
let _SPARC_REG_FCC3 = 52;;
let _SPARC_REG_FP = 53;;
let _SPARC_REG_G0 = 54;;
let _SPARC_REG_G1 = 55;;
let _SPARC_REG_G2 = 56;;
let _SPARC_REG_G3 = 57;;
let _SPARC_REG_G4 = 58;;
let _SPARC_REG_G5 = 59;;
let _SPARC_REG_G6 = 60;;
let _SPARC_REG_G7 = 61;;
let _SPARC_REG_I0 = 62;;
let _SPARC_REG_I1 = 63;;
let _SPARC_REG_I2 = 64;;
let _SPARC_REG_I3 = 65;;
let _SPARC_REG_I4 = 66;;
let _SPARC_REG_I5 = 67;;
let _SPARC_REG_I7 = 68;;
let _SPARC_REG_ICC = 69;;
let _SPARC_REG_L0 = 70;;
let _SPARC_REG_L1 = 71;;
let _SPARC_REG_L2 = 72;;
let _SPARC_REG_L3 = 73;;
let _SPARC_REG_L4 = 74;;
let _SPARC_REG_L5 = 75;;
let _SPARC_REG_L6 = 76;;
let _SPARC_REG_L7 = 77;;
let _SPARC_REG_O0 = 78;;
let _SPARC_REG_O1 = 79;;
let _SPARC_REG_O2 = 80;;
let _SPARC_REG_O3 = 81;;
let _SPARC_REG_O4 = 82;;
let _SPARC_REG_O5 = 83;;
let _SPARC_REG_O7 = 84;;
let _SPARC_REG_SP = 85;;
let _SPARC_REG_Y = 86;;
let _SPARC_REG_MAX = 87;;
let _SPARC_REG_O6 = _SPARC_REG_SP;;
let _SPARC_REG_I6 = _SPARC_REG_FP;;

(*  SPARC instruction *)

let _SPARC_INS_INVALID = 0;;
let _SPARC_INS_ADDCC = 1;;
let _SPARC_INS_ADDX = 2;;
let _SPARC_INS_ADDXCC = 3;;
let _SPARC_INS_ADDXC = 4;;
let _SPARC_INS_ADDXCCC = 5;;
let _SPARC_INS_ADD = 6;;
let _SPARC_INS_ALIGNADDR = 7;;
let _SPARC_INS_ALIGNADDRL = 8;;
let _SPARC_INS_ANDCC = 9;;
let _SPARC_INS_ANDNCC = 10;;
let _SPARC_INS_ANDN = 11;;
let _SPARC_INS_AND = 12;;
let _SPARC_INS_ARRAY16 = 13;;
let _SPARC_INS_ARRAY32 = 14;;
let _SPARC_INS_ARRAY8 = 15;;
let _SPARC_INS_BA = 16;;
let _SPARC_INS_B = 17;;
let _SPARC_INS_JMP = 18;;
let _SPARC_INS_BMASK = 19;;
let _SPARC_INS_FB = 20;;
let _SPARC_INS_BRGEZ = 21;;
let _SPARC_INS_BRGZ = 22;;
let _SPARC_INS_BRLEZ = 23;;
let _SPARC_INS_BRLZ = 24;;
let _SPARC_INS_BRNZ = 25;;
let _SPARC_INS_BRZ = 26;;
let _SPARC_INS_BSHUFFLE = 27;;
let _SPARC_INS_CALL = 28;;
let _SPARC_INS_CASX = 29;;
let _SPARC_INS_CAS = 30;;
let _SPARC_INS_CMASK16 = 31;;
let _SPARC_INS_CMASK32 = 32;;
let _SPARC_INS_CMASK8 = 33;;
let _SPARC_INS_CMP = 34;;
let _SPARC_INS_EDGE16 = 35;;
let _SPARC_INS_EDGE16L = 36;;
let _SPARC_INS_EDGE16LN = 37;;
let _SPARC_INS_EDGE16N = 38;;
let _SPARC_INS_EDGE32 = 39;;
let _SPARC_INS_EDGE32L = 40;;
let _SPARC_INS_EDGE32LN = 41;;
let _SPARC_INS_EDGE32N = 42;;
let _SPARC_INS_EDGE8 = 43;;
let _SPARC_INS_EDGE8L = 44;;
let _SPARC_INS_EDGE8LN = 45;;
let _SPARC_INS_EDGE8N = 46;;
let _SPARC_INS_FABSD = 47;;
let _SPARC_INS_FABSQ = 48;;
let _SPARC_INS_FABSS = 49;;
let _SPARC_INS_FADDD = 50;;
let _SPARC_INS_FADDQ = 51;;
let _SPARC_INS_FADDS = 52;;
let _SPARC_INS_FALIGNDATA = 53;;
let _SPARC_INS_FAND = 54;;
let _SPARC_INS_FANDNOT1 = 55;;
let _SPARC_INS_FANDNOT1S = 56;;
let _SPARC_INS_FANDNOT2 = 57;;
let _SPARC_INS_FANDNOT2S = 58;;
let _SPARC_INS_FANDS = 59;;
let _SPARC_INS_FCHKSM16 = 60;;
let _SPARC_INS_FCMPD = 61;;
let _SPARC_INS_FCMPEQ16 = 62;;
let _SPARC_INS_FCMPEQ32 = 63;;
let _SPARC_INS_FCMPGT16 = 64;;
let _SPARC_INS_FCMPGT32 = 65;;
let _SPARC_INS_FCMPLE16 = 66;;
let _SPARC_INS_FCMPLE32 = 67;;
let _SPARC_INS_FCMPNE16 = 68;;
let _SPARC_INS_FCMPNE32 = 69;;
let _SPARC_INS_FCMPQ = 70;;
let _SPARC_INS_FCMPS = 71;;
let _SPARC_INS_FDIVD = 72;;
let _SPARC_INS_FDIVQ = 73;;
let _SPARC_INS_FDIVS = 74;;
let _SPARC_INS_FDMULQ = 75;;
let _SPARC_INS_FDTOI = 76;;
let _SPARC_INS_FDTOQ = 77;;
let _SPARC_INS_FDTOS = 78;;
let _SPARC_INS_FDTOX = 79;;
let _SPARC_INS_FEXPAND = 80;;
let _SPARC_INS_FHADDD = 81;;
let _SPARC_INS_FHADDS = 82;;
let _SPARC_INS_FHSUBD = 83;;
let _SPARC_INS_FHSUBS = 84;;
let _SPARC_INS_FITOD = 85;;
let _SPARC_INS_FITOQ = 86;;
let _SPARC_INS_FITOS = 87;;
let _SPARC_INS_FLCMPD = 88;;
let _SPARC_INS_FLCMPS = 89;;
let _SPARC_INS_FLUSHW = 90;;
let _SPARC_INS_FMEAN16 = 91;;
let _SPARC_INS_FMOVD = 92;;
let _SPARC_INS_FMOVQ = 93;;
let _SPARC_INS_FMOVRDGEZ = 94;;
let _SPARC_INS_FMOVRQGEZ = 95;;
let _SPARC_INS_FMOVRSGEZ = 96;;
let _SPARC_INS_FMOVRDGZ = 97;;
let _SPARC_INS_FMOVRQGZ = 98;;
let _SPARC_INS_FMOVRSGZ = 99;;
let _SPARC_INS_FMOVRDLEZ = 100;;
let _SPARC_INS_FMOVRQLEZ = 101;;
let _SPARC_INS_FMOVRSLEZ = 102;;
let _SPARC_INS_FMOVRDLZ = 103;;
let _SPARC_INS_FMOVRQLZ = 104;;
let _SPARC_INS_FMOVRSLZ = 105;;
let _SPARC_INS_FMOVRDNZ = 106;;
let _SPARC_INS_FMOVRQNZ = 107;;
let _SPARC_INS_FMOVRSNZ = 108;;
let _SPARC_INS_FMOVRDZ = 109;;
let _SPARC_INS_FMOVRQZ = 110;;
let _SPARC_INS_FMOVRSZ = 111;;
let _SPARC_INS_FMOVS = 112;;
let _SPARC_INS_FMUL8SUX16 = 113;;
let _SPARC_INS_FMUL8ULX16 = 114;;
let _SPARC_INS_FMUL8X16 = 115;;
let _SPARC_INS_FMUL8X16AL = 116;;
let _SPARC_INS_FMUL8X16AU = 117;;
let _SPARC_INS_FMULD = 118;;
let _SPARC_INS_FMULD8SUX16 = 119;;
let _SPARC_INS_FMULD8ULX16 = 120;;
let _SPARC_INS_FMULQ = 121;;
let _SPARC_INS_FMULS = 122;;
let _SPARC_INS_FNADDD = 123;;
let _SPARC_INS_FNADDS = 124;;
let _SPARC_INS_FNAND = 125;;
let _SPARC_INS_FNANDS = 126;;
let _SPARC_INS_FNEGD = 127;;
let _SPARC_INS_FNEGQ = 128;;
let _SPARC_INS_FNEGS = 129;;
let _SPARC_INS_FNHADDD = 130;;
let _SPARC_INS_FNHADDS = 131;;
let _SPARC_INS_FNOR = 132;;
let _SPARC_INS_FNORS = 133;;
let _SPARC_INS_FNOT1 = 134;;
let _SPARC_INS_FNOT1S = 135;;
let _SPARC_INS_FNOT2 = 136;;
let _SPARC_INS_FNOT2S = 137;;
let _SPARC_INS_FONE = 138;;
let _SPARC_INS_FONES = 139;;
let _SPARC_INS_FOR = 140;;
let _SPARC_INS_FORNOT1 = 141;;
let _SPARC_INS_FORNOT1S = 142;;
let _SPARC_INS_FORNOT2 = 143;;
let _SPARC_INS_FORNOT2S = 144;;
let _SPARC_INS_FORS = 145;;
let _SPARC_INS_FPACK16 = 146;;
let _SPARC_INS_FPACK32 = 147;;
let _SPARC_INS_FPACKFIX = 148;;
let _SPARC_INS_FPADD16 = 149;;
let _SPARC_INS_FPADD16S = 150;;
let _SPARC_INS_FPADD32 = 151;;
let _SPARC_INS_FPADD32S = 152;;
let _SPARC_INS_FPADD64 = 153;;
let _SPARC_INS_FPMERGE = 154;;
let _SPARC_INS_FPSUB16 = 155;;
let _SPARC_INS_FPSUB16S = 156;;
let _SPARC_INS_FPSUB32 = 157;;
let _SPARC_INS_FPSUB32S = 158;;
let _SPARC_INS_FQTOD = 159;;
let _SPARC_INS_FQTOI = 160;;
let _SPARC_INS_FQTOS = 161;;
let _SPARC_INS_FQTOX = 162;;
let _SPARC_INS_FSLAS16 = 163;;
let _SPARC_INS_FSLAS32 = 164;;
let _SPARC_INS_FSLL16 = 165;;
let _SPARC_INS_FSLL32 = 166;;
let _SPARC_INS_FSMULD = 167;;
let _SPARC_INS_FSQRTD = 168;;
let _SPARC_INS_FSQRTQ = 169;;
let _SPARC_INS_FSQRTS = 170;;
let _SPARC_INS_FSRA16 = 171;;
let _SPARC_INS_FSRA32 = 172;;
let _SPARC_INS_FSRC1 = 173;;
let _SPARC_INS_FSRC1S = 174;;
let _SPARC_INS_FSRC2 = 175;;
let _SPARC_INS_FSRC2S = 176;;
let _SPARC_INS_FSRL16 = 177;;
let _SPARC_INS_FSRL32 = 178;;
let _SPARC_INS_FSTOD = 179;;
let _SPARC_INS_FSTOI = 180;;
let _SPARC_INS_FSTOQ = 181;;
let _SPARC_INS_FSTOX = 182;;
let _SPARC_INS_FSUBD = 183;;
let _SPARC_INS_FSUBQ = 184;;
let _SPARC_INS_FSUBS = 185;;
let _SPARC_INS_FXNOR = 186;;
let _SPARC_INS_FXNORS = 187;;
let _SPARC_INS_FXOR = 188;;
let _SPARC_INS_FXORS = 189;;
let _SPARC_INS_FXTOD = 190;;
let _SPARC_INS_FXTOQ = 191;;
let _SPARC_INS_FXTOS = 192;;
let _SPARC_INS_FZERO = 193;;
let _SPARC_INS_FZEROS = 194;;
let _SPARC_INS_JMPL = 195;;
let _SPARC_INS_LDD = 196;;
let _SPARC_INS_LD = 197;;
let _SPARC_INS_LDQ = 198;;
let _SPARC_INS_LDSB = 199;;
let _SPARC_INS_LDSH = 200;;
let _SPARC_INS_LDSW = 201;;
let _SPARC_INS_LDUB = 202;;
let _SPARC_INS_LDUH = 203;;
let _SPARC_INS_LDX = 204;;
let _SPARC_INS_LZCNT = 205;;
let _SPARC_INS_MEMBAR = 206;;
let _SPARC_INS_MOVDTOX = 207;;
let _SPARC_INS_MOV = 208;;
let _SPARC_INS_MOVRGEZ = 209;;
let _SPARC_INS_MOVRGZ = 210;;
let _SPARC_INS_MOVRLEZ = 211;;
let _SPARC_INS_MOVRLZ = 212;;
let _SPARC_INS_MOVRNZ = 213;;
let _SPARC_INS_MOVRZ = 214;;
let _SPARC_INS_MOVSTOSW = 215;;
let _SPARC_INS_MOVSTOUW = 216;;
let _SPARC_INS_MULX = 217;;
let _SPARC_INS_NOP = 218;;
let _SPARC_INS_ORCC = 219;;
let _SPARC_INS_ORNCC = 220;;
let _SPARC_INS_ORN = 221;;
let _SPARC_INS_OR = 222;;
let _SPARC_INS_PDIST = 223;;
let _SPARC_INS_PDISTN = 224;;
let _SPARC_INS_POPC = 225;;
let _SPARC_INS_RD = 226;;
let _SPARC_INS_RESTORE = 227;;
let _SPARC_INS_RETT = 228;;
let _SPARC_INS_SAVE = 229;;
let _SPARC_INS_SDIVCC = 230;;
let _SPARC_INS_SDIVX = 231;;
let _SPARC_INS_SDIV = 232;;
let _SPARC_INS_SETHI = 233;;
let _SPARC_INS_SHUTDOWN = 234;;
let _SPARC_INS_SIAM = 235;;
let _SPARC_INS_SLLX = 236;;
let _SPARC_INS_SLL = 237;;
let _SPARC_INS_SMULCC = 238;;
let _SPARC_INS_SMUL = 239;;
let _SPARC_INS_SRAX = 240;;
let _SPARC_INS_SRA = 241;;
let _SPARC_INS_SRLX = 242;;
let _SPARC_INS_SRL = 243;;
let _SPARC_INS_STBAR = 244;;
let _SPARC_INS_STB = 245;;
let _SPARC_INS_STD = 246;;
let _SPARC_INS_ST = 247;;
let _SPARC_INS_STH = 248;;
let _SPARC_INS_STQ = 249;;
let _SPARC_INS_STX = 250;;
let _SPARC_INS_SUBCC = 251;;
let _SPARC_INS_SUBX = 252;;
let _SPARC_INS_SUBXCC = 253;;
let _SPARC_INS_SUB = 254;;
let _SPARC_INS_SWAP = 255;;
let _SPARC_INS_TA = 256;;
let _SPARC_INS_TADDCCTV = 257;;
let _SPARC_INS_TADDCC = 258;;
let _SPARC_INS_T = 259;;
let _SPARC_INS_TSUBCCTV = 260;;
let _SPARC_INS_TSUBCC = 261;;
let _SPARC_INS_UDIVCC = 262;;
let _SPARC_INS_UDIVX = 263;;
let _SPARC_INS_UDIV = 264;;
let _SPARC_INS_UMULCC = 265;;
let _SPARC_INS_UMULXHI = 266;;
let _SPARC_INS_UMUL = 267;;
let _SPARC_INS_UNIMP = 268;;
let _SPARC_INS_FCMPED = 269;;
let _SPARC_INS_FCMPEQ = 270;;
let _SPARC_INS_FCMPES = 271;;
let _SPARC_INS_WR = 272;;
let _SPARC_INS_XMULX = 273;;
let _SPARC_INS_XMULXHI = 274;;
let _SPARC_INS_XNORCC = 275;;
let _SPARC_INS_XNOR = 276;;
let _SPARC_INS_XORCC = 277;;
let _SPARC_INS_XOR = 278;;
let _SPARC_INS_MAX = 279;;

(*  Group of SPARC instructions *)

let _SPARC_GRP_INVALID = 0;;
let _SPARC_GRP_HARDQUAD = 1;;
let _SPARC_GRP_V9 = 2;;
let _SPARC_GRP_VIS = 3;;
let _SPARC_GRP_VIS2 = 4;;
let _SPARC_GRP_VIS3 = 5;;
let _SPARC_GRP_32BIT = 6;;
let _SPARC_GRP_64BIT = 7;;
let _SPARC_GRP_JUMP = 8;;
let _SPARC_GRP_MAX = 9;;
