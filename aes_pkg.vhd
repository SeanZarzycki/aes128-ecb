library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package aes_pkg is

    -- Constants
    constant BLOCK_SIZE : natural := 128;
    constant MATRIX_DIM : natural := 4;

    -- Types
    subtype byte is std_logic_vector(7 downto 0);
    type word is array(0 to 3) of byte;
    


    constant NK : natural := 4;
    constant NR : natural := 10;
    constant NB : natural := 4;

    type CipherKey is array(0 to 4*NK - 1) of byte;

    

    type keySchedule is array(0 to 175) of byte;
    type cipherBlock is array(0 to 4*Nb - 1) of byte;
    subtype byteval is integer range 0 to 255;
    type ByteArray is array(0 to 255) of byteval;
    type rconarray is array(0 to 10) of byteval;

    constant SBOX : ByteArray := (
    16#63#, 16#7C#, 16#77#, 16#7B#, 16#F2#, 16#6B#, 16#6F#, 16#C5#, 16#30#, 16#01#, 16#67#, 16#2B#, 16#FE#, 16#D7#, 16#AB#, 16#76#,
    16#CA#, 16#82#, 16#C9#, 16#7D#, 16#FA#, 16#59#, 16#47#, 16#F0#, 16#AD#, 16#D4#, 16#A2#, 16#AF#, 16#9C#, 16#A4#, 16#72#, 16#C0#,
    16#B7#, 16#FD#, 16#93#, 16#26#, 16#36#, 16#3F#, 16#F7#, 16#CC#, 16#34#, 16#A5#, 16#E5#, 16#F1#, 16#71#, 16#D8#, 16#31#, 16#15#,
    16#04#, 16#C7#, 16#23#, 16#C3#, 16#18#, 16#96#, 16#05#, 16#9A#, 16#07#, 16#12#, 16#80#, 16#E2#, 16#EB#, 16#27#, 16#B2#, 16#75#,
    16#09#, 16#83#, 16#2C#, 16#1A#, 16#1B#, 16#6E#, 16#5A#, 16#A0#, 16#52#, 16#3B#, 16#D6#, 16#B3#, 16#29#, 16#E3#, 16#2F#, 16#84#,
    16#53#, 16#D1#, 16#00#, 16#ED#, 16#20#, 16#FC#, 16#B1#, 16#5B#, 16#6A#, 16#CB#, 16#BE#, 16#39#, 16#4A#, 16#4C#, 16#58#, 16#CF#,
    16#D0#, 16#EF#, 16#AA#, 16#FB#, 16#43#, 16#4D#, 16#33#, 16#85#, 16#45#, 16#F9#, 16#02#, 16#7F#, 16#50#, 16#3C#, 16#9F#, 16#A8#,
    16#51#, 16#A3#, 16#40#, 16#8F#, 16#92#, 16#9D#, 16#38#, 16#F5#, 16#BC#, 16#B6#, 16#DA#, 16#21#, 16#10#, 16#FF#, 16#F3#, 16#D2#,
    16#CD#, 16#0C#, 16#13#, 16#EC#, 16#5F#, 16#97#, 16#44#, 16#17#, 16#C4#, 16#A7#, 16#7E#, 16#3D#, 16#64#, 16#5D#, 16#19#, 16#73#,
    16#60#, 16#81#, 16#4F#, 16#DC#, 16#22#, 16#2A#, 16#90#, 16#88#, 16#46#, 16#EE#, 16#B8#, 16#14#, 16#DE#, 16#5E#, 16#0B#, 16#DB#,
    16#E0#, 16#32#, 16#3A#, 16#0A#, 16#49#, 16#06#, 16#24#, 16#5C#, 16#C2#, 16#D3#, 16#AC#, 16#62#, 16#91#, 16#95#, 16#E4#, 16#79#,
    16#E7#, 16#C8#, 16#37#, 16#6D#, 16#8D#, 16#D5#, 16#4E#, 16#A9#, 16#6C#, 16#56#, 16#F4#, 16#EA#, 16#65#, 16#7A#, 16#AE#, 16#08#,
    16#BA#, 16#78#, 16#25#, 16#2E#, 16#1C#, 16#A6#, 16#B4#, 16#C6#, 16#E8#, 16#DD#, 16#74#, 16#1F#, 16#4B#, 16#BD#, 16#8B#, 16#8A#,
    16#70#, 16#3E#, 16#B5#, 16#66#, 16#48#, 16#03#, 16#F6#, 16#0E#, 16#61#, 16#35#, 16#57#, 16#B9#, 16#86#, 16#C1#, 16#1D#, 16#9E#,
    16#E1#, 16#F8#, 16#98#, 16#11#, 16#69#, 16#D9#, 16#8E#, 16#94#, 16#9B#, 16#1E#, 16#87#, 16#E9#, 16#CE#, 16#55#, 16#28#, 16#DF#,
    16#8C#, 16#A1#, 16#89#, 16#0D#, 16#BF#, 16#E6#, 16#42#, 16#68#, 16#41#, 16#99#, 16#2D#, 16#0F#, 16#B0#, 16#54#, 16#BB#, 16#16#
    );
    
    constant RSBOX : ByteArray := (
        16#52#, 16#09#, 16#6a#, 16#d5#, 16#30#, 16#36#, 16#a5#, 16#38#, 16#bf#, 16#40#, 16#a3#, 16#9e#, 16#81#, 16#f3#, 16#d7#, 16#fb#,
        16#7c#, 16#e3#, 16#39#, 16#82#, 16#9b#, 16#2f#, 16#ff#, 16#87#, 16#34#, 16#8e#, 16#43#, 16#44#, 16#c4#, 16#de#, 16#e9#, 16#cb#,
        16#54#, 16#7b#, 16#94#, 16#32#, 16#a6#, 16#c2#, 16#23#, 16#3d#, 16#ee#, 16#4c#, 16#95#, 16#0b#, 16#42#, 16#fa#, 16#c3#, 16#4e#,
        16#08#, 16#2e#, 16#a1#, 16#66#, 16#28#, 16#d9#, 16#24#, 16#b2#, 16#76#, 16#5b#, 16#a2#, 16#49#, 16#6d#, 16#8b#, 16#d1#, 16#25#,
        16#72#, 16#f8#, 16#f6#, 16#64#, 16#86#, 16#68#, 16#98#, 16#16#, 16#d4#, 16#a4#, 16#5c#, 16#cc#, 16#5d#, 16#65#, 16#b6#, 16#92#,
        16#6c#, 16#70#, 16#48#, 16#50#, 16#fd#, 16#ed#, 16#b9#, 16#da#, 16#5e#, 16#15#, 16#46#, 16#57#, 16#a7#, 16#8d#, 16#9d#, 16#84#,
        16#90#, 16#d8#, 16#ab#, 16#00#, 16#8c#, 16#bc#, 16#d3#, 16#0a#, 16#f7#, 16#e4#, 16#58#, 16#05#, 16#b8#, 16#b3#, 16#45#, 16#06#,
        16#d0#, 16#2c#, 16#1e#, 16#8f#, 16#ca#, 16#3f#, 16#0f#, 16#02#, 16#c1#, 16#af#, 16#bd#, 16#03#, 16#01#, 16#13#, 16#8a#, 16#6b#,
        16#3a#, 16#91#, 16#11#, 16#41#, 16#4f#, 16#67#, 16#dc#, 16#ea#, 16#97#, 16#f2#, 16#cf#, 16#ce#, 16#f0#, 16#b4#, 16#e6#, 16#73#,
        16#96#, 16#ac#, 16#74#, 16#22#, 16#e7#, 16#ad#, 16#35#, 16#85#, 16#e2#, 16#f9#, 16#37#, 16#e8#, 16#1c#, 16#75#, 16#df#, 16#6e#,
        16#47#, 16#f1#, 16#1a#, 16#71#, 16#1d#, 16#29#, 16#c5#, 16#89#, 16#6f#, 16#b7#, 16#62#, 16#0e#, 16#aa#, 16#18#, 16#be#, 16#1b#,
        16#fc#, 16#56#, 16#3e#, 16#4b#, 16#c6#, 16#d2#, 16#79#, 16#20#, 16#9a#, 16#db#, 16#c0#, 16#fe#, 16#78#, 16#cd#, 16#5a#, 16#f4#,
        16#1f#, 16#dd#, 16#a8#, 16#33#, 16#88#, 16#07#, 16#c7#, 16#31#, 16#b1#, 16#12#, 16#10#, 16#59#, 16#27#, 16#80#, 16#ec#, 16#5f#,
        16#60#, 16#51#, 16#7f#, 16#a9#, 16#19#, 16#b5#, 16#4a#, 16#0d#, 16#2d#, 16#e5#, 16#7a#, 16#9f#, 16#93#, 16#c9#, 16#9c#, 16#ef#,
        16#a0#, 16#e0#, 16#3b#, 16#4d#, 16#ae#, 16#2a#, 16#f5#, 16#b0#, 16#c8#, 16#eb#, 16#bb#, 16#3c#, 16#83#, 16#53#, 16#99#, 16#61#,
        16#17#, 16#2b#, 16#04#, 16#7e#, 16#ba#, 16#77#, 16#d6#, 16#26#, 16#e1#, 16#69#, 16#14#, 16#63#, 16#55#, 16#21#, 16#0c#, 16#7d#
    );

    constant RCON : rconarray := (
    16#8D#, 16#01#, 16#02#, 16#04#, 16#08#, 16#10#, 16#20#, 16#40#, 16#80#, 16#1B#, 16#36# 
    );

    function GMul(a, b : in byte) return byte;
    function xtime(x : in byte) return byte;
    function SubWord(x : in Word) return Word;
    function RotWord(x : in Word) return Word;
    function KeyExpansion(key : in CipherKey; constant nk : in natural) return keySchedule;
    function Cipher(plaintext : in cipherBlock; key : in cipherkey) return cipherBlock;
    function InvCipher(ciphertext : in cipherBlock; key : in cipherkey) return cipherBlock;
    function SubBytes(state : in cipherBlock) return cipherBlock;
    function ShiftRows(s : in cipherBlock) return cipherBlock;
    function ShiftRow(stateRow : in word; rowNum : in natural) return word;
    function InvShiftRow(stateRow : in word; rowNum : in natural) return word;
    
    function MixColumn(col : in word) return word;
    function MixColumns(state : in cipherBlock) return cipherBlock;
    function AddRoundKey(state : in cipherBlock; RoundKey : keyschedule; roundNumber : natural) return cipherBlock;
    function InvSubBytes(state : in cipherBlock) return cipherBlock;
    function InvShiftRows(s : in cipherBlock) return cipherBlock;
    function Multiply(x, y : in byte) return byte;
    function InvMixColumn(col : in word) return word;
    function InvMixColumns(state : in cipherBlock) return cipherBlock;    

    
end aes_pkg;

package body aes_pkg is
    
    function GMul(a, b : in byte) return byte is
        variable ax : byte := a;
        variable bx : byte := b;
        variable p : byte := x"00";
        variable HiBitSet : boolean;
        begin
            for i in 0 to 7 loop
                if bx(0) = '1' then
                    p := p XOR ax;
                end if;
                HiBitSet := ax(7) = '1';
                ax := Byte(shift_left(unsigned(ax), 1));
                if HiBitSet then
                    ax := ax XOR x"1b";
                end if;
                bx := Byte(shift_right(unsigned(bx), 1));
            end loop;
            return p;
        end;
    
    function xtime(x : in byte) return byte is
            variable ret : byte;
            variable a, b, c, d : byte;
            variable ux : unsigned(7 downto 0) := unsigned(x);
            begin
                a := x(6 downto 0) & '0';
                if x(7) = '1' then 
                    c := x"1b";
                else 
                    c := x"00";
                end if;
                
                ret := c XOR a;
                return ret;
            end;
    
    function KeyExpansion(key : in CipherKey; constant nk : in natural) -- wor
      return keySchedule is
        
        variable temp : word;
        variable roundkey : KeySchedule;
        variable j,k : natural;
        begin
          for i in 0 to 15 loop
              roundkey(i) := key(i);
          end loop;


            for i in Nk to Nb * (Nr + 1) - 1 loop
                k := (i - 1) * 4;
                temp := word(roundkey(k to k + 3));
                if (i mod Nk = 0) then
                    temp := rotword(temp);
                    temp := subword(temp);
                    temp(0) := temp(0) XOR std_logic_vector(to_unsigned(RCON(i / nk), 8));
         
                end if;
                j := i * 4;
                k := (i - nk) * 4;
                roundkey(j + 0) := roundkey(k + 0) XOR temp(0);
                roundkey(j + 1) := roundkey(k + 1) XOR temp(1);
                roundkey(j + 2) := roundkey(k + 2) XOR temp(2);
                roundkey(j + 3) := roundkey(k + 3) XOR temp(3);

            end loop;
            return roundkey;
        end;
    
    function SubWord(x : in Word) return Word is
        variable sub : Word;
        begin
        for i in 0 to x'length - 1 loop
            sub(i) := std_logic_vector(to_unsigned(SBOX(to_integer(unsigned(x(i)))), 8));
        end loop;
        return sub;
        end;
    
    function RotWord(x : in Word) return Word is
        variable rot: Word;
        begin
            rot := (x(1), x(2), x(3), x(0));
            return rot;
        end;

    function Cipher(plaintext : in cipherBlock; key : in cipherkey) return cipherBlock is
        variable ciphertext : cipherBlock;
        variable state : cipherBlock;
        variable roundkey : cipherkey;
        variable w : keyschedule := KeyExpansion(key, nk);
        begin
            state := plaintext;

            state := AddRoundKey(state, w, 0);

            for r in 1 to Nr-1 loop
                state := subBytes(state);
                state := shiftrows(state);
                state := mixColumns(state);
                state := addRoundKey(state, w, r);
            end loop;

            state := subbytes(state);
            state := shiftrows(state);
            state := addroundkey(state, w, 10);

            return state;
        end;    
        

        

        
    function SubBytes(state : in cipherBlock) return cipherBlock is
        variable sub : cipherblock;
        begin
        for i in 0 to 15 loop
            sub(i) := std_logic_vector(to_unsigned(SBOX(to_integer(unsigned(state(i)))), 8));
        end loop;
        return sub;
        end;

        function InvCipher(ciphertext : in cipherBlock; key : in cipherkey) return cipherBlock is
            variable state : cipherBlock;
            variable roundkey : cipherkey;
            variable w : keyschedule := KeyExpansion(key, nk);
            begin
                state := ciphertext;
        
                state := AddRoundKey(state, w, 10);
    
                for r in Nr-1 downto 1 loop
                    state := invshiftrows(state);
                    state := invsubBytes(state);
                    state := addRoundKey(state, w, r);
                    state := invmixColumns(state);
                end loop;
                
                state := invshiftrows(state);
                state := invsubbytes(state);
                state := addroundkey(state, w, 0);
    
                return state;
            end; 

        function ShiftRows(s : in cipherBlock) return cipherBlock is
            variable ns : cipherblock;
            variable temp : byte;
            variable row : word;
            variable shiftedrow : word;
            begin
                 ns := (s(0), s(5), s(10), s(15),
                        s(4), s(9), s(14), s(3),
                        s(8), s(13), s(2), s(7),
                        s(12), s(1), s(6), s(11));
                return ns;
            end; 
            
    function ShiftRow(stateRow : in word; rowNum : natural) return word is
        variable shifted : word;
        begin
            for i in 0 to MATRIX_DIM - 1 loop
                shifted((i - rowNum + MATRIX_DIM) mod MATRIX_DIM) := stateRow(i);
            end loop;
            return shifted;
        end;
        
    function InvShiftRow(stateRow : in word; rowNum : natural) return word is
        variable shifted : word;
        begin
            for i in 0 to MATRIX_DIM - 1 loop
                shifted((i + rowNum + MATRIX_DIM) mod MATRIX_DIM) := stateRow(i);
            end loop;
            return shifted;
        end;
        
    function MixColumns(state : in cipherBlock) return cipherBlock is
        variable mixed : cipherblock;
        variable col, col2 : word;
        variable tmp, tm, t : byte;
        begin
                for c in 0 to 3 loop
                    mixed(c*4) := Gmul(x"02", state(c*4)) XOR GMul(x"03", state(c*4 + 1)) XOR state(c*4 + 2) XOR state(c*4 + 3);
                    mixed(c*4 + 1) := state(c*4) XOR GMul(x"02", state(c*4 + 1)) XOR GMul(x"03",state(c*4 + 2)) XOR state(c*4 + 3);
                    mixed(c*4 + 2) := state(c*4) XOR state(c*4 + 1) XOR GMul(x"02",state(c*4 + 2)) XOR GMul(x"03",state(c*4 + 3));
                    mixed(c*4 + 3) := GMul(x"03",state(c*4)) XOR state(c*4 + 1) XOR state(c*4 + 2) XOR GMul(x"02",state(c*4 + 3));
                end loop;
            return mixed;
        end;
        
    function MixColumn(col : in word) return word is
            variable mixed : word;
            begin
            mixed(0) := Gmul(x"02", col(0)) XOR GMul(x"03", col(1)) XOR col(2) XOR col(3);
                                mixed(1) := col(0) XOR GMul(x"02", col( + 1)) XOR GMul(x"03",col(2)) XOR col(3);
                                mixed(2) := col(0) XOR col(1) XOR GMul(x"02",col(2)) XOR GMul(x"03",col(3));
                                mixed(3) := GMul(x"03",col(0)) XOR col(1) XOR col(2) XOR GMul(x"02",col(3));
            return mixed;
            end;
    

    function AddRoundKey(state : in cipherBlock; RoundKey : keyschedule; roundNumber : natural) return cipherBlock is
        variable NextState : CipherBlock;
        begin

            for i in 0 to 3 loop
                for j in 0 to 3 loop
                    NextState(i * 4 + j) := 
                    state(i * 4 + j) XOR 
                    RoundKey((roundNumber * NB * 4) + (i * Nb) + j);
                end loop;
            end loop;
            return nextstate;
        end;

    function InvSubBytes(state : in cipherBlock) return cipherBlock is
        variable sub : cipherblock;
        begin
        for i in 0 to state'length - 1 loop
            sub(i) := std_logic_vector(to_unsigned(RSBOX(to_integer(unsigned(state(i)))), 8));
        end loop;
        return sub;
        end;

    function InvShiftRows(s : in cipherBlock) return cipherBlock is
        variable ns : cipherblock;
        begin
            ns := (s(0), s(13), s(10), s(7),
                    s(4), s(1), s(14), s(11),
                    s(8), s(5), s(2), s(15),
                    s(12), s(9), s(6), s(3));
            return ns;
        end;

    function Multiply(x, y : in byte) return byte is
        variable z : byte;
        variable ux, uy : unsigned(7 downto 0);
        variable uz : unsigned(15 downto 0);
        begin
            ux := unsigned(x);
            uy := unsigned(y);
            
            uz := (((uy AND x"01") * ux) XOR
            ((shift_right(uy, 1) AND x"01") * unsigned(xtime(x))) XOR
            ((shift_right(uy, 2) AND x"01") * unsigned(xtime(xtime(x)))) XOR
            ((shift_right(uy, 3) AND x"01") * unsigned(xtime(xtime(xtime(x))))) XOR
            ((shift_right(uy, 4) AND x"01") * unsigned(xtime(xtime(xtime(xtime(x)))))));
            z := std_logic_vector(uz(7 downto 0));
            return z;
        end;

    function InvMixColumn(col : in word) return word is
        variable mixed : word;
        variable a, b, c, d : byte;
        begin
            
            for i in 0 to 3 loop
                a := col(0);
                b := col(1);
                c := col(2);
                d := col(3);

                mixed(0) := Multiply(a, x"0e") XOR Multiply(b, x"0b") XOR Multiply(c, x"0d") XOR Multiply(d, x"09");
                mixed(1) := Multiply(a, x"09") XOR Multiply(b, x"0e") XOR Multiply(c, x"0b") XOR Multiply(d, x"0d");
                mixed(2) := Multiply(a, x"0d") XOR Multiply(b, x"09") XOR Multiply(c, x"0e") XOR Multiply(d, x"0b");
                mixed(3) := Multiply(a, x"0b") XOR Multiply(b, x"0d") XOR Multiply(c, x"09") XOR Multiply(d, x"0e");
            end loop;   
            return mixed;                   
        end;

    function InvMixColumns(state : in cipherBlock) return cipherBlock is
        variable mixed : cipherblock;
        variable a, b, c, d : byte;
        begin
            for i in 0 to 3 loop
                a := state(i * 4);
                b := state(i * 4 + 1);
                c := state(i * 4 + 2);
                d := state(i * 4 + 3);

                mixed(i*4) := Multiply(a, x"0e") XOR Multiply(b, x"0b") XOR Multiply(c, x"0d") XOR Multiply(d, x"09");
                mixed(i*4 + 1) := Multiply(a, x"09") XOR Multiply(b, x"0e") XOR Multiply(c, x"0b") XOR Multiply(d, x"0d");
                mixed(i*4 + 2) := Multiply(a, x"0d") XOR Multiply(b, x"09") XOR Multiply(c, x"0e") XOR Multiply(d, x"0b");
                mixed(i*4 + 3) := Multiply(a, x"0b") XOR Multiply(b, x"0d") XOR Multiply(c, x"09") XOR Multiply(d, x"0e");
            end loop;   
            return mixed;         
        end;
        
end aes_pkg;