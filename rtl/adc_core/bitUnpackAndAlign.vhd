library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity bitUnpackAndAlign is
  port(

    rst_n_i           : in std_logic;
    -- ADC sampling clock (fDCO / 8)
    clk_adc_i         : in std_logic;
    -- Raw ADC data including the FCO line (used for bit alignment)
    serdes_data_raw_i : in std_logic_vector(71 downto 0);

    -- ADC data output
    ch_a_data_o : out std_logic_vector(15 downto 0);
    ch_b_data_o : out std_logic_vector(15 downto 0);
    ch_c_data_o : out std_logic_vector(15 downto 0);
    ch_d_data_o : out std_logic_vector(15 downto 0);

    -- Bitslip trigger
    bitslip_o : out std_logic
    );

end bitUnpackAndAlign;

architecture Behavioral of bitUnpackAndAlign is

  signal serdes_out_data : std_logic_vector(63 downto 0);
  signal serdes_out_fr   : std_logic_vector(7 downto 0);
  signal serdes_synced   : std_logic;
  signal serdes_bitslip  : std_logic := '0';
  signal count           : std_logic_vector(1 downto 0);
  signal test            : std_logic_vector(7 downto 0);

  signal cnt : unsigned(5 downto 0);


begin

-- Sort all the raw data from the SERDES. 
--    out_data(15:0)  = CH1
--    out_data(31:16) = CH2
--    out_data(47:32) = CH3
--    out_data(63:48) = CH4

  gen_serdes_dout_reorder : for I in 0 to 7 generate
    serdes_out_data(15 - 2*i)   <= serdes_data_raw_i(1 + i*9);
    serdes_out_data(15 - 2*i-1) <= serdes_data_raw_i(0 + i*9);
    serdes_out_data(31 - 2*i)   <= serdes_data_raw_i(3 + i*9);
    serdes_out_data(31 - 2*i-1) <= serdes_data_raw_i(2 + i*9);
    serdes_out_data(47 - 2*i)   <= serdes_data_raw_i(5 + i*9);
    serdes_out_data(47 - 2*i-1) <= serdes_data_raw_i(4 + i*9);
    serdes_out_data(63 - 2*i)   <= serdes_data_raw_i(7 + i*9);
    serdes_out_data(63 - 2*i-1) <= serdes_data_raw_i(6 + i*9);
    serdes_out_fr(i)            <= serdes_data_raw_i(8 + i*9);  -- FR
  end generate gen_serdes_dout_reorder;


  process(clk_adc_i)
  begin
    if rising_edge(clk_adc_i) then
      if rst_n_i = '0' then             -- Synchronous reset
        ch_a_data_o <= (others => '0');
        ch_b_data_o <= (others => '0');
        ch_c_data_o <= (others => '0');
        ch_d_data_o <= (others => '0');
      else  -- Data spread on different buses and sign conserved
        ch_a_data_o <= serdes_out_data(15) & serdes_out_data(15) & serdes_out_data(15 downto 2);
        ch_b_data_o <= serdes_out_data(31) & serdes_out_data(31) & serdes_out_data(31 downto 18);
        ch_c_data_o <= serdes_out_data(47) & serdes_out_data(47) & serdes_out_data(47 downto 34);
        ch_d_data_o <= serdes_out_data(63) & serdes_out_data(63) & serdes_out_data(63 downto 50);
      end if;
    end if;
  end process;

-- SERDES bitslip generation
-- All the bits are shifted together if the frame clock is not 
-- well reconstructed. The bitslip signal cannot be continuous,
-- each time we have to wait for new incoming data to check if
-- the frame clock is correct.

  bitslip_gen : process(clk_adc_i, rst_n_i)
  begin
    if rising_edge(clk_adc_i) then
      if rst_n_i = '0' then
        serdes_bitslip <= '0';
        serdes_synced  <= '0';
        cnt            <= (others => '0');
      else
        cnt <= cnt + 1;

        if cnt = 0 and serdes_out_fr /= X"0f" then  -- Attention to the polarity
          serdes_synced  <= '0';
          serdes_bitslip <= '1';
        elsif cnt = 20 and serdes_out_fr = X"0f" then
          serdes_synced  <= '1';
          serdes_bitslip <= '0';
        else
          serdes_bitslip <= '0';
        end if;
      end if;
    end if;
  end process;

  bitslip_o <= serdes_bitslip;

end Behavioral;
