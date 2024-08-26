`timescale 1ns / 1ps


module kernel_table(
input wire clk,
      
input wire rd_en,
input wire [8:0] addr,//0~256
   
output wire [9:0] dout0,
output wire [9:0] dout1,
output wire [9:0] dout2,
output wire [9:0] dout3
);

//变量声明
reg [9:0] rom_data0, rom_data1, rom_data2, rom_data3;
    
//查表
always@(posedge clk ) begin
    if(rd_en) begin
        case(addr)
        default: begin rom_data0 <= 0; rom_data1 <= 256;  rom_data2 <= 0; rom_data3 <= 0; end
        1: begin rom_data0 <= 0; rom_data1 <= 255;  rom_data2 <= 0; rom_data3 <= 0; end
        2: begin rom_data0 <= 0; rom_data1 <= 255;  rom_data2 <= 1; rom_data3 <= 0; end
        3: begin rom_data0 <= -1; rom_data1 <= 255;  rom_data2 <= 1; rom_data3 <= 0; end
        4: begin rom_data0 <= -1; rom_data1 <= 255;  rom_data2 <= 2; rom_data3 <= 0; end
        5: begin rom_data0 <= -2; rom_data1 <= 255;  rom_data2 <= 2; rom_data3 <= 0; end
        6: begin rom_data0 <= -2; rom_data1 <= 255;  rom_data2 <= 3; rom_data3 <= 0; end
        7: begin rom_data0 <= -3; rom_data1 <= 255;  rom_data2 <= 3; rom_data3 <= 0; end
        8: begin rom_data0 <= -3; rom_data1 <= 255;  rom_data2 <= 4; rom_data3 <= 0; end
        9: begin rom_data0 <= -4; rom_data1 <= 255;  rom_data2 <= 5; rom_data3 <= 0; end
        10: begin rom_data0 <= -4; rom_data1 <= 255;  rom_data2 <= 5; rom_data3 <= 0; end
        11: begin rom_data0 <= -5; rom_data1 <= 254;  rom_data2 <= 6; rom_data3 <= 0; end
        12: begin rom_data0 <= -5; rom_data1 <= 254;  rom_data2 <= 7; rom_data3 <= 0; end
        13: begin rom_data0 <= -5; rom_data1 <= 254;  rom_data2 <= 7; rom_data3 <= 0; end
        14: begin rom_data0 <= -6; rom_data1 <= 254;  rom_data2 <= 8; rom_data3 <= 0; end
        15: begin rom_data0 <= -6; rom_data1 <= 253;  rom_data2 <= 9; rom_data3 <= 0; end
        16: begin rom_data0 <= -7; rom_data1 <= 253;  rom_data2 <= 9; rom_data3 <= 0; end
        17: begin rom_data0 <= -7; rom_data1 <= 253;  rom_data2 <= 10; rom_data3 <= 0; end
        18: begin rom_data0 <= -7; rom_data1 <= 252;  rom_data2 <= 11; rom_data3 <= 0; end
        19: begin rom_data0 <= -8; rom_data1 <= 252;  rom_data2 <= 12; rom_data3 <= 0; end
        20: begin rom_data0 <= -8; rom_data1 <= 252;  rom_data2 <= 12; rom_data3 <= 0; end
        21: begin rom_data0 <= -8; rom_data1 <= 251;  rom_data2 <= 13; rom_data3 <= 0; end
        22: begin rom_data0 <= -9; rom_data1 <= 251;  rom_data2 <= 14; rom_data3 <= 0; end
        23: begin rom_data0 <= -9; rom_data1 <= 251;  rom_data2 <= 15; rom_data3 <= 0; end
        24: begin rom_data0 <= -9; rom_data1 <= 250;  rom_data2 <= 16; rom_data3 <= -1; end
        25: begin rom_data0 <= -10; rom_data1 <= 250;  rom_data2 <= 17; rom_data3 <= -1; end
        26: begin rom_data0 <= -10; rom_data1 <= 249;  rom_data2 <= 17; rom_data3 <= -1; end
        27: begin rom_data0 <= -10; rom_data1 <= 249;  rom_data2 <= 18; rom_data3 <= -1; end
        28: begin rom_data0 <= -11; rom_data1 <= 248;  rom_data2 <= 19; rom_data3 <= -1; end
        29: begin rom_data0 <= -11; rom_data1 <= 248;  rom_data2 <= 20; rom_data3 <= -1; end
        30: begin rom_data0 <= -11; rom_data1 <= 247;  rom_data2 <= 21; rom_data3 <= -1; end
        31: begin rom_data0 <= -11; rom_data1 <= 247;  rom_data2 <= 22; rom_data3 <= -1; end
        32: begin rom_data0 <= -12; rom_data1 <= 246;  rom_data2 <= 23; rom_data3 <= -1; end
        33: begin rom_data0 <= -12; rom_data1 <= 246;  rom_data2 <= 24; rom_data3 <= -1; end
        34: begin rom_data0 <= -12; rom_data1 <= 245;  rom_data2 <= 25; rom_data3 <= -1; end
        35: begin rom_data0 <= -13; rom_data1 <= 245;  rom_data2 <= 26; rom_data3 <= -2; end
        36: begin rom_data0 <= -13; rom_data1 <= 244;  rom_data2 <= 27; rom_data3 <= -2; end
        37: begin rom_data0 <= -13; rom_data1 <= 243;  rom_data2 <= 28; rom_data3 <= -2; end
        38: begin rom_data0 <= -13; rom_data1 <= 243;  rom_data2 <= 29; rom_data3 <= -2; end
        39: begin rom_data0 <= -14; rom_data1 <= 242;  rom_data2 <= 30; rom_data3 <= -2; end
        40: begin rom_data0 <= -14; rom_data1 <= 241;  rom_data2 <= 31; rom_data3 <= -2; end
        41: begin rom_data0 <= -14; rom_data1 <= 241;  rom_data2 <= 32; rom_data3 <= -2; end
        42: begin rom_data0 <= -14; rom_data1 <= 240;  rom_data2 <= 33; rom_data3 <= -2; end
        43: begin rom_data0 <= -14; rom_data1 <= 239;  rom_data2 <= 34; rom_data3 <= -3; end
        44: begin rom_data0 <= -15; rom_data1 <= 239;  rom_data2 <= 35; rom_data3 <= -3; end
        45: begin rom_data0 <= -15; rom_data1 <= 238;  rom_data2 <= 36; rom_data3 <= -3; end
        46: begin rom_data0 <= -15; rom_data1 <= 237;  rom_data2 <= 37; rom_data3 <= -3; end
        47: begin rom_data0 <= -15; rom_data1 <= 236;  rom_data2 <= 38; rom_data3 <= -3; end
        48: begin rom_data0 <= -15; rom_data1 <= 236;  rom_data2 <= 39; rom_data3 <= -3; end
        49: begin rom_data0 <= -16; rom_data1 <= 235;  rom_data2 <= 40; rom_data3 <= -3; end
        50: begin rom_data0 <= -16; rom_data1 <= 234;  rom_data2 <= 41; rom_data3 <= -3; end
        51: begin rom_data0 <= -16; rom_data1 <= 233;  rom_data2 <= 42; rom_data3 <= -4; end
        52: begin rom_data0 <= -16; rom_data1 <= 232;  rom_data2 <= 43; rom_data3 <= -4; end
        53: begin rom_data0 <= -16; rom_data1 <= 231;  rom_data2 <= 45; rom_data3 <= -4; end
        54: begin rom_data0 <= -16; rom_data1 <= 231;  rom_data2 <= 46; rom_data3 <= -4; end
        55: begin rom_data0 <= -16; rom_data1 <= 230;  rom_data2 <= 47; rom_data3 <= -4; end
        56: begin rom_data0 <= -17; rom_data1 <= 229;  rom_data2 <= 48; rom_data3 <= -4; end
        57: begin rom_data0 <= -17; rom_data1 <= 228;  rom_data2 <= 49; rom_data3 <= -4; end
        58: begin rom_data0 <= -17; rom_data1 <= 227;  rom_data2 <= 50; rom_data3 <= -5; end
        59: begin rom_data0 <= -17; rom_data1 <= 226;  rom_data2 <= 51; rom_data3 <= -5; end
        60: begin rom_data0 <= -17; rom_data1 <= 225;  rom_data2 <= 53; rom_data3 <= -5; end
        61: begin rom_data0 <= -17; rom_data1 <= 224;  rom_data2 <= 54; rom_data3 <= -5; end
        62: begin rom_data0 <= -17; rom_data1 <= 223;  rom_data2 <= 55; rom_data3 <= -5; end
        63: begin rom_data0 <= -17; rom_data1 <= 222;  rom_data2 <= 56; rom_data3 <= -5; end
        64: begin rom_data0 <= -18; rom_data1 <= 222;  rom_data2 <= 58; rom_data3 <= -6; end
        65: begin rom_data0 <= -18; rom_data1 <= 221;  rom_data2 <= 59; rom_data3 <= -6; end
        66: begin rom_data0 <= -18; rom_data1 <= 220;  rom_data2 <= 60; rom_data3 <= -6; end
        67: begin rom_data0 <= -18; rom_data1 <= 219;  rom_data2 <= 61; rom_data3 <= -6; end
        68: begin rom_data0 <= -18; rom_data1 <= 218;  rom_data2 <= 62; rom_data3 <= -6; end
        69: begin rom_data0 <= -18; rom_data1 <= 217;  rom_data2 <= 64; rom_data3 <= -6; end
        70: begin rom_data0 <= -18; rom_data1 <= 215;  rom_data2 <= 65; rom_data3 <= -6; end
        71: begin rom_data0 <= -18; rom_data1 <= 214;  rom_data2 <= 66; rom_data3 <= -7; end
        72: begin rom_data0 <= -18; rom_data1 <= 213;  rom_data2 <= 67; rom_data3 <= -7; end
        73: begin rom_data0 <= -18; rom_data1 <= 212;  rom_data2 <= 69; rom_data3 <= -7; end
        74: begin rom_data0 <= -18; rom_data1 <= 211;  rom_data2 <= 70; rom_data3 <= -7; end
        75: begin rom_data0 <= -18; rom_data1 <= 210;  rom_data2 <= 71; rom_data3 <= -7; end
        76: begin rom_data0 <= -18; rom_data1 <= 209;  rom_data2 <= 73; rom_data3 <= -7; end
        77: begin rom_data0 <= -18; rom_data1 <= 208;  rom_data2 <= 74; rom_data3 <= -8; end
        78: begin rom_data0 <= -18; rom_data1 <= 207;  rom_data2 <= 75; rom_data3 <= -8; end
        79: begin rom_data0 <= -18; rom_data1 <= 206;  rom_data2 <= 76; rom_data3 <= -8; end
        80: begin rom_data0 <= -18; rom_data1 <= 205;  rom_data2 <= 78; rom_data3 <= -8; end
        81: begin rom_data0 <= -18; rom_data1 <= 204;  rom_data2 <= 79; rom_data3 <= -8; end
        82: begin rom_data0 <= -18; rom_data1 <= 202;  rom_data2 <= 80; rom_data3 <= -8; end
        83: begin rom_data0 <= -18; rom_data1 <= 201;  rom_data2 <= 82; rom_data3 <= -9; end
        84: begin rom_data0 <= -18; rom_data1 <= 200;  rom_data2 <= 83; rom_data3 <= -9; end
        85: begin rom_data0 <= -18; rom_data1 <= 199;  rom_data2 <= 84; rom_data3 <= -9; end
        86: begin rom_data0 <= -18; rom_data1 <= 198;  rom_data2 <= 86; rom_data3 <= -9; end
        87: begin rom_data0 <= -18; rom_data1 <= 197;  rom_data2 <= 87; rom_data3 <= -9; end
        88: begin rom_data0 <= -18; rom_data1 <= 195;  rom_data2 <= 88; rom_data3 <= -9; end
        89: begin rom_data0 <= -18; rom_data1 <= 194;  rom_data2 <= 90; rom_data3 <= -10; end
        90: begin rom_data0 <= -18; rom_data1 <= 193;  rom_data2 <= 91; rom_data3 <= -10; end
        91: begin rom_data0 <= -18; rom_data1 <= 192;  rom_data2 <= 92; rom_data3 <= -10; end
        92: begin rom_data0 <= -18; rom_data1 <= 191;  rom_data2 <= 94; rom_data3 <= -10; end
        93: begin rom_data0 <= -18; rom_data1 <= 189;  rom_data2 <= 95; rom_data3 <= -10; end
        94: begin rom_data0 <= -18; rom_data1 <= 188;  rom_data2 <= 97; rom_data3 <= -10; end
        95: begin rom_data0 <= -18; rom_data1 <= 187;  rom_data2 <= 98; rom_data3 <= -11; end
        96: begin rom_data0 <= -18; rom_data1 <= 186;  rom_data2 <= 99; rom_data3 <= -11; end
        97: begin rom_data0 <= -18; rom_data1 <= 185;  rom_data2 <= 101; rom_data3 <= -11; end
        98: begin rom_data0 <= -18; rom_data1 <= 183;  rom_data2 <= 102; rom_data3 <= -11; end
        99: begin rom_data0 <= -18; rom_data1 <= 182;  rom_data2 <= 103; rom_data3 <= -11; end
        100: begin rom_data0 <= -18; rom_data1 <= 181;  rom_data2 <= 105; rom_data3 <= -11; end
        101: begin rom_data0 <= -18; rom_data1 <= 179;  rom_data2 <= 106; rom_data3 <= -12; end
        102: begin rom_data0 <= -18; rom_data1 <= 178;  rom_data2 <= 107; rom_data3 <= -12; end
        103: begin rom_data0 <= -18; rom_data1 <= 177;  rom_data2 <= 109; rom_data3 <= -12; end
        104: begin rom_data0 <= -18; rom_data1 <= 176;  rom_data2 <= 110; rom_data3 <= -12; end
        105: begin rom_data0 <= -18; rom_data1 <= 174;  rom_data2 <= 112; rom_data3 <= -12; end
        106: begin rom_data0 <= -18; rom_data1 <= 173;  rom_data2 <= 113; rom_data3 <= -12; end
        107: begin rom_data0 <= -18; rom_data1 <= 172;  rom_data2 <= 114; rom_data3 <= -13; end
        108: begin rom_data0 <= -18; rom_data1 <= 170;  rom_data2 <= 116; rom_data3 <= -13; end
        109: begin rom_data0 <= -17; rom_data1 <= 169;  rom_data2 <= 117; rom_data3 <= -13; end
        110: begin rom_data0 <= -17; rom_data1 <= 168;  rom_data2 <= 119; rom_data3 <= -13; end
        111: begin rom_data0 <= -17; rom_data1 <= 166;  rom_data2 <= 120; rom_data3 <= -13; end
        112: begin rom_data0 <= -17; rom_data1 <= 165;  rom_data2 <= 121; rom_data3 <= -13; end
        113: begin rom_data0 <= -17; rom_data1 <= 164;  rom_data2 <= 123; rom_data3 <= -13; end
        114: begin rom_data0 <= -17; rom_data1 <= 162;  rom_data2 <= 124; rom_data3 <= -14; end
        115: begin rom_data0 <= -17; rom_data1 <= 161;  rom_data2 <= 126; rom_data3 <= -14; end
        116: begin rom_data0 <= -17; rom_data1 <= 160;  rom_data2 <= 127; rom_data3 <= -14; end
        117: begin rom_data0 <= -17; rom_data1 <= 158;  rom_data2 <= 128; rom_data3 <= -14; end
        118: begin rom_data0 <= -17; rom_data1 <= 157;  rom_data2 <= 130; rom_data3 <= -14; end
        119: begin rom_data0 <= -17; rom_data1 <= 156;  rom_data2 <= 131; rom_data3 <= -14; end
        120: begin rom_data0 <= -16; rom_data1 <= 154;  rom_data2 <= 132; rom_data3 <= -14; end
        121: begin rom_data0 <= -16; rom_data1 <= 153;  rom_data2 <= 134; rom_data3 <= -15; end
        122: begin rom_data0 <= -16; rom_data1 <= 152;  rom_data2 <= 135; rom_data3 <= -15; end
        123: begin rom_data0 <= -16; rom_data1 <= 150;  rom_data2 <= 137; rom_data3 <= -15; end
        124: begin rom_data0 <= -16; rom_data1 <= 149;  rom_data2 <= 138; rom_data3 <= -15; end
        125: begin rom_data0 <= -16; rom_data1 <= 148;  rom_data2 <= 139; rom_data3 <= -15; end
        126: begin rom_data0 <= -16; rom_data1 <= 146;  rom_data2 <= 141; rom_data3 <= -15; end
        127: begin rom_data0 <= -16; rom_data1 <= 145;  rom_data2 <= 142; rom_data3 <= -15; end
        128: begin rom_data0 <= -16; rom_data1 <= 144;  rom_data2 <= 144; rom_data3 <= -16; end
        129: begin rom_data0 <= -15; rom_data1 <= 142;  rom_data2 <= 145; rom_data3 <= -16; end
        130: begin rom_data0 <= -15; rom_data1 <= 141;  rom_data2 <= 146; rom_data3 <= -16; end
        131: begin rom_data0 <= -15; rom_data1 <= 139;  rom_data2 <= 148; rom_data3 <= -16; end
        132: begin rom_data0 <= -15; rom_data1 <= 138;  rom_data2 <= 149; rom_data3 <= -16; end
        133: begin rom_data0 <= -15; rom_data1 <= 137;  rom_data2 <= 150; rom_data3 <= -16; end
        134: begin rom_data0 <= -15; rom_data1 <= 135;  rom_data2 <= 152; rom_data3 <= -16; end
        135: begin rom_data0 <= -15; rom_data1 <= 134;  rom_data2 <= 153; rom_data3 <= -16; end
        136: begin rom_data0 <= -14; rom_data1 <= 132;  rom_data2 <= 154; rom_data3 <= -16; end
        137: begin rom_data0 <= -14; rom_data1 <= 131;  rom_data2 <= 156; rom_data3 <= -17; end
        138: begin rom_data0 <= -14; rom_data1 <= 130;  rom_data2 <= 157; rom_data3 <= -17; end
        139: begin rom_data0 <= -14; rom_data1 <= 128;  rom_data2 <= 158; rom_data3 <= -17; end
        140: begin rom_data0 <= -14; rom_data1 <= 127;  rom_data2 <= 160; rom_data3 <= -17; end
        141: begin rom_data0 <= -14; rom_data1 <= 126;  rom_data2 <= 161; rom_data3 <= -17; end
        142: begin rom_data0 <= -14; rom_data1 <= 124;  rom_data2 <= 162; rom_data3 <= -17; end
        143: begin rom_data0 <= -13; rom_data1 <= 123;  rom_data2 <= 164; rom_data3 <= -17; end
        144: begin rom_data0 <= -13; rom_data1 <= 121;  rom_data2 <= 165; rom_data3 <= -17; end
        145: begin rom_data0 <= -13; rom_data1 <= 120;  rom_data2 <= 166; rom_data3 <= -17; end
        146: begin rom_data0 <= -13; rom_data1 <= 119;  rom_data2 <= 168; rom_data3 <= -17; end
        147: begin rom_data0 <= -13; rom_data1 <= 117;  rom_data2 <= 169; rom_data3 <= -17; end
        148: begin rom_data0 <= -13; rom_data1 <= 116;  rom_data2 <= 170; rom_data3 <= -18; end
        149: begin rom_data0 <= -13; rom_data1 <= 114;  rom_data2 <= 172; rom_data3 <= -18; end
        150: begin rom_data0 <= -12; rom_data1 <= 113;  rom_data2 <= 173; rom_data3 <= -18; end
        151: begin rom_data0 <= -12; rom_data1 <= 112;  rom_data2 <= 174; rom_data3 <= -18; end
        152: begin rom_data0 <= -12; rom_data1 <= 110;  rom_data2 <= 176; rom_data3 <= -18; end
        153: begin rom_data0 <= -12; rom_data1 <= 109;  rom_data2 <= 177; rom_data3 <= -18; end
        154: begin rom_data0 <= -12; rom_data1 <= 107;  rom_data2 <= 178; rom_data3 <= -18; end
        155: begin rom_data0 <= -12; rom_data1 <= 106;  rom_data2 <= 179; rom_data3 <= -18; end
        156: begin rom_data0 <= -11; rom_data1 <= 105;  rom_data2 <= 181; rom_data3 <= -18; end
        157: begin rom_data0 <= -11; rom_data1 <= 103;  rom_data2 <= 182; rom_data3 <= -18; end
        158: begin rom_data0 <= -11; rom_data1 <= 102;  rom_data2 <= 183; rom_data3 <= -18; end
        159: begin rom_data0 <= -11; rom_data1 <= 101;  rom_data2 <= 185; rom_data3 <= -18; end
        160: begin rom_data0 <= -11; rom_data1 <= 99;  rom_data2 <= 186; rom_data3 <= -18; end
        161: begin rom_data0 <= -11; rom_data1 <= 98;  rom_data2 <= 187; rom_data3 <= -18; end
        162: begin rom_data0 <= -10; rom_data1 <= 97;  rom_data2 <= 188; rom_data3 <= -18; end
        163: begin rom_data0 <= -10; rom_data1 <= 95;  rom_data2 <= 189; rom_data3 <= -18; end
        164: begin rom_data0 <= -10; rom_data1 <= 94;  rom_data2 <= 191; rom_data3 <= -18; end
        165: begin rom_data0 <= -10; rom_data1 <= 92;  rom_data2 <= 192; rom_data3 <= -18; end
        166: begin rom_data0 <= -10; rom_data1 <= 91;  rom_data2 <= 193; rom_data3 <= -18; end
        167: begin rom_data0 <= -10; rom_data1 <= 90;  rom_data2 <= 194; rom_data3 <= -18; end
        168: begin rom_data0 <= -9; rom_data1 <= 88;  rom_data2 <= 195; rom_data3 <= -18; end
        169: begin rom_data0 <= -9; rom_data1 <= 87;  rom_data2 <= 197; rom_data3 <= -18; end
        170: begin rom_data0 <= -9; rom_data1 <= 86;  rom_data2 <= 198; rom_data3 <= -18; end
        171: begin rom_data0 <= -9; rom_data1 <= 84;  rom_data2 <= 199; rom_data3 <= -18; end
        172: begin rom_data0 <= -9; rom_data1 <= 83;  rom_data2 <= 200; rom_data3 <= -18; end
        173: begin rom_data0 <= -9; rom_data1 <= 82;  rom_data2 <= 201; rom_data3 <= -18; end
        174: begin rom_data0 <= -8; rom_data1 <= 80;  rom_data2 <= 202; rom_data3 <= -18; end
        175: begin rom_data0 <= -8; rom_data1 <= 79;  rom_data2 <= 204; rom_data3 <= -18; end
        176: begin rom_data0 <= -8; rom_data1 <= 78;  rom_data2 <= 205; rom_data3 <= -18; end
        177: begin rom_data0 <= -8; rom_data1 <= 76;  rom_data2 <= 206; rom_data3 <= -18; end
        178: begin rom_data0 <= -8; rom_data1 <= 75;  rom_data2 <= 207; rom_data3 <= -18; end
        179: begin rom_data0 <= -8; rom_data1 <= 74;  rom_data2 <= 208; rom_data3 <= -18; end
        180: begin rom_data0 <= -7; rom_data1 <= 73;  rom_data2 <= 209; rom_data3 <= -18; end
        181: begin rom_data0 <= -7; rom_data1 <= 71;  rom_data2 <= 210; rom_data3 <= -18; end
        182: begin rom_data0 <= -7; rom_data1 <= 70;  rom_data2 <= 211; rom_data3 <= -18; end
        183: begin rom_data0 <= -7; rom_data1 <= 69;  rom_data2 <= 212; rom_data3 <= -18; end
        184: begin rom_data0 <= -7; rom_data1 <= 67;  rom_data2 <= 213; rom_data3 <= -18; end
        185: begin rom_data0 <= -7; rom_data1 <= 66;  rom_data2 <= 214; rom_data3 <= -18; end
        186: begin rom_data0 <= -6; rom_data1 <= 65;  rom_data2 <= 215; rom_data3 <= -18; end
        187: begin rom_data0 <= -6; rom_data1 <= 64;  rom_data2 <= 217; rom_data3 <= -18; end
        188: begin rom_data0 <= -6; rom_data1 <= 62;  rom_data2 <= 218; rom_data3 <= -18; end
        189: begin rom_data0 <= -6; rom_data1 <= 61;  rom_data2 <= 219; rom_data3 <= -18; end
        190: begin rom_data0 <= -6; rom_data1 <= 60;  rom_data2 <= 220; rom_data3 <= -18; end
        191: begin rom_data0 <= -6; rom_data1 <= 59;  rom_data2 <= 221; rom_data3 <= -18; end
        192: begin rom_data0 <= -6; rom_data1 <= 58;  rom_data2 <= 222; rom_data3 <= -18; end
        193: begin rom_data0 <= -5; rom_data1 <= 56;  rom_data2 <= 222; rom_data3 <= -17; end
        194: begin rom_data0 <= -5; rom_data1 <= 55;  rom_data2 <= 223; rom_data3 <= -17; end
        195: begin rom_data0 <= -5; rom_data1 <= 54;  rom_data2 <= 224; rom_data3 <= -17; end
        196: begin rom_data0 <= -5; rom_data1 <= 53;  rom_data2 <= 225; rom_data3 <= -17; end
        197: begin rom_data0 <= -5; rom_data1 <= 51;  rom_data2 <= 226; rom_data3 <= -17; end
        198: begin rom_data0 <= -5; rom_data1 <= 50;  rom_data2 <= 227; rom_data3 <= -17; end
        199: begin rom_data0 <= -4; rom_data1 <= 49;  rom_data2 <= 228; rom_data3 <= -17; end
        200: begin rom_data0 <= -4; rom_data1 <= 48;  rom_data2 <= 229; rom_data3 <= -17; end
        201: begin rom_data0 <= -4; rom_data1 <= 47;  rom_data2 <= 230; rom_data3 <= -16; end
        202: begin rom_data0 <= -4; rom_data1 <= 46;  rom_data2 <= 231; rom_data3 <= -16; end
        203: begin rom_data0 <= -4; rom_data1 <= 45;  rom_data2 <= 231; rom_data3 <= -16; end
        204: begin rom_data0 <= -4; rom_data1 <= 43;  rom_data2 <= 232; rom_data3 <= -16; end
        205: begin rom_data0 <= -4; rom_data1 <= 42;  rom_data2 <= 233; rom_data3 <= -16; end
        206: begin rom_data0 <= -3; rom_data1 <= 41;  rom_data2 <= 234; rom_data3 <= -16; end
        207: begin rom_data0 <= -3; rom_data1 <= 40;  rom_data2 <= 235; rom_data3 <= -16; end
        208: begin rom_data0 <= -3; rom_data1 <= 39;  rom_data2 <= 236; rom_data3 <= -15; end
        209: begin rom_data0 <= -3; rom_data1 <= 38;  rom_data2 <= 236; rom_data3 <= -15; end
        210: begin rom_data0 <= -3; rom_data1 <= 37;  rom_data2 <= 237; rom_data3 <= -15; end
        211: begin rom_data0 <= -3; rom_data1 <= 36;  rom_data2 <= 238; rom_data3 <= -15; end
        212: begin rom_data0 <= -3; rom_data1 <= 35;  rom_data2 <= 239; rom_data3 <= -15; end
        213: begin rom_data0 <= -3; rom_data1 <= 34;  rom_data2 <= 239; rom_data3 <= -14; end
        214: begin rom_data0 <= -2; rom_data1 <= 33;  rom_data2 <= 240; rom_data3 <= -14; end
        215: begin rom_data0 <= -2; rom_data1 <= 32;  rom_data2 <= 241; rom_data3 <= -14; end
        216: begin rom_data0 <= -2; rom_data1 <= 31;  rom_data2 <= 241; rom_data3 <= -14; end
        217: begin rom_data0 <= -2; rom_data1 <= 30;  rom_data2 <= 242; rom_data3 <= -14; end
        218: begin rom_data0 <= -2; rom_data1 <= 29;  rom_data2 <= 243; rom_data3 <= -13; end
        219: begin rom_data0 <= -2; rom_data1 <= 28;  rom_data2 <= 243; rom_data3 <= -13; end
        220: begin rom_data0 <= -2; rom_data1 <= 27;  rom_data2 <= 244; rom_data3 <= -13; end
        221: begin rom_data0 <= -2; rom_data1 <= 26;  rom_data2 <= 245; rom_data3 <= -13; end
        222: begin rom_data0 <= -1; rom_data1 <= 25;  rom_data2 <= 245; rom_data3 <= -12; end
        223: begin rom_data0 <= -1; rom_data1 <= 24;  rom_data2 <= 246; rom_data3 <= -12; end
        224: begin rom_data0 <= -1; rom_data1 <= 23;  rom_data2 <= 246; rom_data3 <= -12; end
        225: begin rom_data0 <= -1; rom_data1 <= 22;  rom_data2 <= 247; rom_data3 <= -11; end
        226: begin rom_data0 <= -1; rom_data1 <= 21;  rom_data2 <= 247; rom_data3 <= -11; end
        227: begin rom_data0 <= -1; rom_data1 <= 20;  rom_data2 <= 248; rom_data3 <= -11; end
        228: begin rom_data0 <= -1; rom_data1 <= 19;  rom_data2 <= 248; rom_data3 <= -11; end
        229: begin rom_data0 <= -1; rom_data1 <= 18;  rom_data2 <= 249; rom_data3 <= -10; end
        230: begin rom_data0 <= -1; rom_data1 <= 17;  rom_data2 <= 249; rom_data3 <= -10; end
        231: begin rom_data0 <= -1; rom_data1 <= 17;  rom_data2 <= 250; rom_data3 <= -10; end
        232: begin rom_data0 <= -1; rom_data1 <= 16;  rom_data2 <= 250; rom_data3 <= -9; end
        233: begin rom_data0 <= 0; rom_data1 <= 15;  rom_data2 <= 251; rom_data3 <= -9; end
        234: begin rom_data0 <= 0; rom_data1 <= 14;  rom_data2 <= 251; rom_data3 <= -9; end
        235: begin rom_data0 <= 0; rom_data1 <= 13;  rom_data2 <= 251; rom_data3 <= -8; end
        236: begin rom_data0 <= 0; rom_data1 <= 12;  rom_data2 <= 252; rom_data3 <= -8; end
        237: begin rom_data0 <= 0; rom_data1 <= 12;  rom_data2 <= 252; rom_data3 <= -8; end
        238: begin rom_data0 <= 0; rom_data1 <= 11;  rom_data2 <= 252; rom_data3 <= -7; end
        239: begin rom_data0 <= 0; rom_data1 <= 10;  rom_data2 <= 253; rom_data3 <= -7; end
        240: begin rom_data0 <= 0; rom_data1 <= 9;  rom_data2 <= 253; rom_data3 <= -7; end
        241: begin rom_data0 <= 0; rom_data1 <= 9;  rom_data2 <= 253; rom_data3 <= -6; end
        242: begin rom_data0 <= 0; rom_data1 <= 8;  rom_data2 <= 254; rom_data3 <= -6; end
        243: begin rom_data0 <= 0; rom_data1 <= 7;  rom_data2 <= 254; rom_data3 <= -5; end
        244: begin rom_data0 <= 0; rom_data1 <= 7;  rom_data2 <= 254; rom_data3 <= -5; end
        245: begin rom_data0 <= 0; rom_data1 <= 6;  rom_data2 <= 254; rom_data3 <= -5; end
        246: begin rom_data0 <= 0; rom_data1 <= 5;  rom_data2 <= 255; rom_data3 <= -4; end
        247: begin rom_data0 <= 0; rom_data1 <= 5;  rom_data2 <= 255; rom_data3 <= -4; end
        248: begin rom_data0 <= 0; rom_data1 <= 4;  rom_data2 <= 255; rom_data3 <= -3; end
        249: begin rom_data0 <= 0; rom_data1 <= 3;  rom_data2 <= 255; rom_data3 <= -3; end
        250: begin rom_data0 <= 0; rom_data1 <= 3;  rom_data2 <= 255; rom_data3 <= -2; end
        251: begin rom_data0 <= 0; rom_data1 <= 2;  rom_data2 <= 255; rom_data3 <= -2; end
        252: begin rom_data0 <= 0; rom_data1 <= 2;  rom_data2 <= 255; rom_data3 <= -1; end
        253: begin rom_data0 <= 0; rom_data1 <= 1;  rom_data2 <= 255; rom_data3 <= -1; end
        254: begin rom_data0 <= 0; rom_data1 <= 1;  rom_data2 <= 255; rom_data3 <= 0; end
        255: begin rom_data0 <= 0; rom_data1 <= 0;  rom_data2 <= 255; rom_data3 <= 0; end  
        endcase
    end
end
    
assign dout0 = rom_data0;
assign dout1 = rom_data1;
assign dout2 = rom_data2;
assign dout3 = rom_data3;
    
endmodule
