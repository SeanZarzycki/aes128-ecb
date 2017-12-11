library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.aes_pkg.all;

package aes_ecb_breaker is
    type KeyVal is record 
        Key : CipherBlock;
        Value : byte;
    end record KeyVal;
    type Dictionary is array(0 to 255) of KeyVal;
    function Oracle_ECB_Decrypt(unknowntext : cipherblock; key : cipherkey) return cipherblock;

    end aes_ecb_breaker;

package body aes_ecb_breaker is
    
    function Oracle_ECB_Decrypt(unknowntext : cipherblock; key : cipherkey) return cipherblock is
        variable plaintext : cipherblock;
        variable ciphertext : cipherblock;
        variable temp, temp2 : cipherblock;
        variable ctlen : natural := 144;
        variable dict : dictionary;
        variable done : boolean := false;
        variable guess : cipherblock := (x"00",x"00",x"00",x"00",
                                         x"00",x"00",x"00",x"00",
                                         x"00",x"00",x"00",x"00",
                                         x"00",x"00",x"00",x"00");

        
        begin
            -- build up the dictionary
            

            for i in 0 to 15 loop
                for j in 0 to 255 loop
                    guess(15) := byte(to_unsigned(j, 8));
                    dict(j).value := guess(15);
                    temp := cipher(guess, key);
                    dict(j).key := temp;
                end loop;
                
                guess(15) := unknowntext(i);
                temp := cipher(guess, key);
                for c in 0 to 255 loop
                    if temp = dict(c).key then
                        plaintext(i) := dict(c).value;
                    end if;
                end loop;
                
                guess := (guess(1 to 15) & x"00");
            end loop;
            return plaintext;
        end;
    end aes_ecb_breaker;