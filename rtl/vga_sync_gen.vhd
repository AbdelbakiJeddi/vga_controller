library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sync_gen is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        hsync    : out std_logic;
        vsync    : out std_logic;
        video_on : out std_logic;
        pixel_x  : out std_logic_vector(9 downto 0);
        pixel_y  : out std_logic_vector(9 downto 0)
    );
end entity vga_sync_gen;

architecture rtl of vga_sync_gen is

    signal h_count_reg : unsigned(9 downto 0) := (others => '0');
    signal v_count_reg : unsigned(9 downto 0) := (others => '0');

    signal hsync_reg    : std_logic := '1';
    signal vsync_reg    : std_logic := '1';
    signal video_on_reg : std_logic := '0';

begin

    sync_counters: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                h_count_reg <= (others => '0');
                v_count_reg <= (others => '0');
            else
                if h_count_reg = 799 then
                    h_count_reg <= (others => '0');

                    if v_count_reg = 524 then
                        v_count_reg <= (others => '0');
                    else
                        v_count_reg <= v_count_reg + 1;
                    end if;
                else
                    h_count_reg <= h_count_reg + 1;
                end if;
            end if;
        end if;
    end process sync_counters;

    output_registers: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                hsync_reg    <= '1';
                vsync_reg    <= '1';
                video_on_reg <= '0';
            else
                -- Sync pulses are '0' and asserted during their porch intervals.
                if (h_count_reg >= 656) and (h_count_reg <= 751) then 
                    hsync_reg <= '0';
                else
                    hsync_reg <= '1';
                end if;

                if (v_count_reg >= 490) and (v_count_reg <= 491) then
                    vsync_reg <= '0';
                else
                    vsync_reg <= '1';
                end if;

                -- video_on is : '1' only inside the visible 640x480 area.
                --               '0' during blanking intervals.
                if (h_count_reg < 640) and (v_count_reg < 480) then
                    video_on_reg <= '1';
                else
                    video_on_reg <= '0';
                end if;
            end if;
        end if;
    end process output_registers;

    hsync    <= hsync_reg;
    vsync    <= vsync_reg;
    video_on <= video_on_reg;
    pixel_x  <= std_logic_vector(h_count_reg);
    pixel_y  <= std_logic_vector(v_count_reg);

end architecture rtl;
