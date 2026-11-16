library ieee;
use ieee.std_logic_1164.all;

entity vga_top is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        hsync : out std_logic;
        vsync : out std_logic;
        red   : out std_logic_vector(3 downto 0);
        green : out std_logic_vector(3 downto 0);
        blue  : out std_logic_vector(3 downto 0)
    );
end entity vga_top;

architecture structural of vga_top is

    signal w_video_on : std_logic;
    signal w_pixel_x  : std_logic_vector(9 downto 0);
    signal w_pixel_y  : std_logic_vector(9 downto 0);

begin

    u_sync_gen: entity work.vga_sync_gen(rtl)
        port map (
            clk      => clk,
            rst      => rst,
            hsync    => hsync,
            vsync    => vsync,
            video_on => w_video_on,
            pixel_x  => w_pixel_x,
            pixel_y  => w_pixel_y
        );

    u_pixel_gen: entity work.pixel_generator(rtl)
        port map (
            video_on => w_video_on,
            pixel_x  => w_pixel_x,
            pixel_y  => w_pixel_y,
            red      => red,
            green    => green,
            blue     => blue
        );

end architecture structural;
