`timescale 1ns / 1ps

module sin_table(
   input wire clk,
      
   input wire rd_en,
   input wire [8:0] addr,//0~360，表示旋转角度
   
   output wire [8:0] dout
    );

    //变量声明
    reg [8:0] rom_data;
    
    //查表
    always@(posedge clk ) begin
        if(rd_en) begin
            case(addr)
            default: rom_data <= 0;
            1: rom_data <= 4;
            2: rom_data <= 8;
            3: rom_data <= 13;
            4: rom_data <= 17;
            5: rom_data <= 22;
            6: rom_data <= 26;
            7: rom_data <= 31;
            8: rom_data <= 35;
            9: rom_data <= 39;
            10: rom_data <= 44;
            11: rom_data <= 48;
            12: rom_data <= 53;
            13: rom_data <= 57;
            14: rom_data <= 61;
            15: rom_data <= 65;
            16: rom_data <= 70;
            17: rom_data <= 74;
            18: rom_data <= 78;
            19: rom_data <= 83;
            20: rom_data <= 87;
            21: rom_data <= 91;
            22: rom_data <= 95;
            23: rom_data <= 99;
            24: rom_data <= 103;
            25: rom_data <= 107;
            26: rom_data <= 111;
            27: rom_data <= 115;
            28: rom_data <= 119;
            29: rom_data <= 123;
            30: rom_data <= 127;
            31: rom_data <= 131;
            32: rom_data <= 135;
            33: rom_data <= 138;
            34: rom_data <= 142;
            35: rom_data <= 146;
            36: rom_data <= 149;
            37: rom_data <= 153;
            38: rom_data <= 156;
            39: rom_data <= 160;
            40: rom_data <= 163;
            41: rom_data <= 167;
            42: rom_data <= 170;
            43: rom_data <= 173;
            44: rom_data <= 177;
            45: rom_data <= 180;
            46: rom_data <= 183;
            47: rom_data <= 186;
            48: rom_data <= 189;
            49: rom_data <= 192;
            50: rom_data <= 195;
            51: rom_data <= 198;
            52: rom_data <= 200;
            53: rom_data <= 203;
            54: rom_data <= 206;
            55: rom_data <= 208;
            56: rom_data <= 211;
            57: rom_data <= 213;
            58: rom_data <= 216;
            59: rom_data <= 218;
            60: rom_data <= 220;
            61: rom_data <= 223;
            62: rom_data <= 225;
            63: rom_data <= 227;
            64: rom_data <= 229;
            65: rom_data <= 231;
            66: rom_data <= 232;
            67: rom_data <= 234;
            68: rom_data <= 236;
            69: rom_data <= 238;
            70: rom_data <= 239;
            71: rom_data <= 241;
            72: rom_data <= 242;
            73: rom_data <= 243;
            74: rom_data <= 245;
            75: rom_data <= 246;
            76: rom_data <= 247;
            77: rom_data <= 248;
            78: rom_data <= 249;
            79: rom_data <= 250;
            80: rom_data <= 251;
            81: rom_data <= 251;
            82: rom_data <= 252;
            83: rom_data <= 253;
            84: rom_data <= 253;
            85: rom_data <= 254;
            86: rom_data <= 254;
            87: rom_data <= 254;
            88: rom_data <= 254;
            89: rom_data <= 254;
            90: rom_data <= 255;
            91: rom_data <= 254;
            92: rom_data <= 254;
            93: rom_data <= 254;
            94: rom_data <= 254;
            95: rom_data <= 254;
            96: rom_data <= 253;
            97: rom_data <= 253;
            98: rom_data <= 252;
            99: rom_data <= 251;
            100: rom_data <= 251;
            101: rom_data <= 250;
            102: rom_data <= 249;
            103: rom_data <= 248;
            104: rom_data <= 247;
            105: rom_data <= 246;
            106: rom_data <= 245;
            107: rom_data <= 243;
            108: rom_data <= 242;
            109: rom_data <= 241;
            110: rom_data <= 239;
            111: rom_data <= 238;
            112: rom_data <= 236;
            113: rom_data <= 234;
            114: rom_data <= 232;
            115: rom_data <= 231;
            116: rom_data <= 229;
            117: rom_data <= 227;
            118: rom_data <= 225;
            119: rom_data <= 223;
            120: rom_data <= 220;
            121: rom_data <= 218;
            122: rom_data <= 216;
            123: rom_data <= 213;
            124: rom_data <= 211;
            125: rom_data <= 208;
            126: rom_data <= 206;
            127: rom_data <= 203;
            128: rom_data <= 200;
            129: rom_data <= 198;
            130: rom_data <= 195;
            131: rom_data <= 192;
            132: rom_data <= 189;
            133: rom_data <= 186;
            134: rom_data <= 183;
            135: rom_data <= 180;
            136: rom_data <= 177;
            137: rom_data <= 173;
            138: rom_data <= 170;
            139: rom_data <= 167;
            140: rom_data <= 163;
            141: rom_data <= 160;
            142: rom_data <= 156;
            143: rom_data <= 153;
            144: rom_data <= 149;
            145: rom_data <= 146;
            146: rom_data <= 142;
            147: rom_data <= 138;
            148: rom_data <= 135;
            149: rom_data <= 131;
            150: rom_data <= 127;
            151: rom_data <= 123;
            152: rom_data <= 119;
            153: rom_data <= 115;
            154: rom_data <= 111;
            155: rom_data <= 107;
            156: rom_data <= 103;
            157: rom_data <= 99;
            158: rom_data <= 95;
            159: rom_data <= 91;
            160: rom_data <= 87;
            161: rom_data <= 83;
            162: rom_data <= 78;
            163: rom_data <= 74;
            164: rom_data <= 70;
            165: rom_data <= 65;
            166: rom_data <= 61;
            167: rom_data <= 57;
            168: rom_data <= 53;
            169: rom_data <= 48;
            170: rom_data <= 44;
            171: rom_data <= 39;
            172: rom_data <= 35;
            173: rom_data <= 31;
            174: rom_data <= 26;
            175: rom_data <= 22;
            176: rom_data <= 17;
            177: rom_data <= 13;
            178: rom_data <= 8;
            179: rom_data <= 4;
            180: rom_data <= 0;
            181: rom_data <= -4;
            182: rom_data <= -8;
            183: rom_data <= -13;
            184: rom_data <= -17;
            185: rom_data <= -22;
            186: rom_data <= -26;
            187: rom_data <= -31;
            188: rom_data <= -35;
            189: rom_data <= -39;
            190: rom_data <= -44;
            191: rom_data <= -48;
            192: rom_data <= -53;
            193: rom_data <= -57;
            194: rom_data <= -61;
            195: rom_data <= -65;
            196: rom_data <= -70;
            197: rom_data <= -74;
            198: rom_data <= -78;
            199: rom_data <= -83;
            200: rom_data <= -87;
            201: rom_data <= -91;
            202: rom_data <= -95;
            203: rom_data <= -99;
            204: rom_data <= -103;
            205: rom_data <= -107;
            206: rom_data <= -111;
            207: rom_data <= -115;
            208: rom_data <= -119;
            209: rom_data <= -123;
            210: rom_data <= -127;
            211: rom_data <= -131;
            212: rom_data <= -135;
            213: rom_data <= -138;
            214: rom_data <= -142;
            215: rom_data <= -146;
            216: rom_data <= -149;
            217: rom_data <= -153;
            218: rom_data <= -156;
            219: rom_data <= -160;
            220: rom_data <= -163;
            221: rom_data <= -167;
            222: rom_data <= -170;
            223: rom_data <= -173;
            224: rom_data <= -177;
            225: rom_data <= -180;
            226: rom_data <= -183;
            227: rom_data <= -186;
            228: rom_data <= -189;
            229: rom_data <= -192;
            230: rom_data <= -195;
            231: rom_data <= -198;
            232: rom_data <= -200;
            233: rom_data <= -203;
            234: rom_data <= -206;
            235: rom_data <= -208;
            236: rom_data <= -211;
            237: rom_data <= -213;
            238: rom_data <= -216;
            239: rom_data <= -218;
            240: rom_data <= -220;
            241: rom_data <= -223;
            242: rom_data <= -225;
            243: rom_data <= -227;
            244: rom_data <= -229;
            245: rom_data <= -231;
            246: rom_data <= -232;
            247: rom_data <= -234;
            248: rom_data <= -236;
            249: rom_data <= -238;
            250: rom_data <= -239;
            251: rom_data <= -241;
            252: rom_data <= -242;
            253: rom_data <= -243;
            254: rom_data <= -245;
            255: rom_data <= -246;
            256: rom_data <= -247;
            257: rom_data <= -248;
            258: rom_data <= -249;
            259: rom_data <= -250;
            260: rom_data <= -251;
            261: rom_data <= -251;
            262: rom_data <= -252;
            263: rom_data <= -253;
            264: rom_data <= -253;
            265: rom_data <= -254;
            266: rom_data <= -254;
            267: rom_data <= -254;
            268: rom_data <= -254;
            269: rom_data <= -254;
            270: rom_data <= -255;
            271: rom_data <= -254;
            272: rom_data <= -254;
            273: rom_data <= -254;
            274: rom_data <= -254;
            275: rom_data <= -254;
            276: rom_data <= -253;
            277: rom_data <= -253;
            278: rom_data <= -252;
            279: rom_data <= -251;
            280: rom_data <= -251;
            281: rom_data <= -250;
            282: rom_data <= -249;
            283: rom_data <= -248;
            284: rom_data <= -247;
            285: rom_data <= -246;
            286: rom_data <= -245;
            287: rom_data <= -243;
            288: rom_data <= -242;
            289: rom_data <= -241;
            290: rom_data <= -239;
            291: rom_data <= -238;
            292: rom_data <= -236;
            293: rom_data <= -234;
            294: rom_data <= -232;
            295: rom_data <= -231;
            296: rom_data <= -229;
            297: rom_data <= -227;
            298: rom_data <= -225;
            299: rom_data <= -223;
            300: rom_data <= -220;
            301: rom_data <= -218;
            302: rom_data <= -216;
            303: rom_data <= -213;
            304: rom_data <= -211;
            305: rom_data <= -208;
            306: rom_data <= -206;
            307: rom_data <= -203;
            308: rom_data <= -200;
            309: rom_data <= -198;
            310: rom_data <= -195;
            311: rom_data <= -192;
            312: rom_data <= -189;
            313: rom_data <= -186;
            314: rom_data <= -183;
            315: rom_data <= -180;
            316: rom_data <= -177;
            317: rom_data <= -173;
            318: rom_data <= -170;
            319: rom_data <= -167;
            320: rom_data <= -163;
            321: rom_data <= -160;
            322: rom_data <= -156;
            323: rom_data <= -153;
            324: rom_data <= -149;
            325: rom_data <= -146;
            326: rom_data <= -142;
            327: rom_data <= -138;
            328: rom_data <= -135;
            329: rom_data <= -131;
            330: rom_data <= -127;
            331: rom_data <= -123;
            332: rom_data <= -119;
            333: rom_data <= -115;
            334: rom_data <= -111;
            335: rom_data <= -107;
            336: rom_data <= -103;
            337: rom_data <= -99;
            338: rom_data <= -95;
            339: rom_data <= -91;
            340: rom_data <= -87;
            341: rom_data <= -83;
            342: rom_data <= -78;
            343: rom_data <= -74;
            344: rom_data <= -70;
            345: rom_data <= -65;
            346: rom_data <= -61;
            347: rom_data <= -57;
            348: rom_data <= -53;
            349: rom_data <= -48;
            350: rom_data <= -44;
            351: rom_data <= -39;
            352: rom_data <= -35;
            353: rom_data <= -31;
            354: rom_data <= -26;
            355: rom_data <= -22;
            356: rom_data <= -17;
            357: rom_data <= -13;
            358: rom_data <= -8;
            359: rom_data <= -4;            
            endcase
        end
    end
    
    assign dout = rom_data;
    
endmodule
