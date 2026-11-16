library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pixel_generator is
    port (
        video_on: in  std_logic;
        pixel_x : in  std_logic_vector(9 downto 0);
        pixel_y : in  std_logic_vector(9 downto 0);
        red     : out std_logic_vector(3 downto 0);
        green   : out std_logic_vector(3 downto 0);
        blue    : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of pixel_generator is

begin

    gen_process: process (video_on, pixel_x)
    begin
        if video_on = '0' then
            red   <= (others => '0');
            green <= (others => '0');
            blue  <= (others => '0');
        else
            if  unsigned(pixel_x) < 80 then -- White
                red   <= "1111";
                green <= "1111";
                blue  <= "1111";
            elsif  unsigned(pixel_x) < 160 then -- Yellow
                red   <= "1111"; 
                green <= "1111";
                blue  <= "0000";
            elsif  unsigned(pixel_x) < 240 then -- Cyan
                red   <= "0000"; 
                green <= "1111";
                blue  <= "1111";
            elsif  unsigned(pixel_x) < 320 then -- Green
                red   <= "0000"; 
                green <= "1111";
                blue  <= "0000";
            elsif  unsigned(pixel_x) < 400 then -- Magenta
                red   <= "1111"; 
                green <= "0000";
                blue  <= "1111";
            elsif  unsigned(pixel_x) < 480 then -- Red
                red   <= "1111"; 
                green <= "0000";
                blue  <= "0000";
            elsif  unsigned(pixel_x) < 560 then --Blue
                red   <= "0000"; 
                green <= "0000";
                blue  <= "1111";
            else                                -- Black
                red   <= "0000"; 
                green <= "0000";
                blue  <= "0000";
            end if;
                
        end if;
    end process;

end architecture;