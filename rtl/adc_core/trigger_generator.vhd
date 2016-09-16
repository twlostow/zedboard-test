library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use work.wishbone_pkg.all;
use work.tg_wbgen2_pkg.all;

entity trigger_generator is
  port (
    clk_adc_i : in std_logic;
    clk_sys_i : in std_logic;

    rst_n_sys_i : in std_logic;
    rst_n_adc_i : in std_logic;

    samples_i : in std_logic_vector(15 downto 0);

    slave_i : in  t_wishbone_slave_in;
    slave_o : out t_wishbone_slave_out;

    -- bus trigger output to all 4 channels of the ADC
    trig_bus_o : out std_logic_vector(3 downto 0)
    );

end trigger_generator;

architecture rtl of trigger_generator is

  component trigger_generator_wb is
    port (
      rst_n_i    : in  std_logic;
      clk_sys_i  : in  std_logic;
      wb_adr_i   : in  std_logic_vector(1 downto 0);
      wb_dat_i   : in  std_logic_vector(31 downto 0);
      wb_dat_o   : out std_logic_vector(31 downto 0);
      wb_cyc_i   : in  std_logic;
      wb_sel_i   : in  std_logic_vector(3 downto 0);
      wb_stb_i   : in  std_logic;
      wb_we_i    : in  std_logic;
      wb_ack_o   : out std_logic;
      wb_stall_o : out std_logic;
      clk_acq_i  : in  std_logic;
      regs_i     : in  t_tg_in_registers;
      regs_o     : out t_tg_out_registers);
  end component trigger_generator_wb;
  
  signal x, thr_lo, thr_hi : signed(15 downto 0);

  signal regs_out : t_tg_out_registers;
  signal regs_in  : t_tg_in_registers;

  type t_state is (IDLE, ARMED, WAIT_THR_LO, THR_LO_HIT);
  signal state : t_state;
begin
  x      <= signed(samples_i);
  thr_lo <= signed(regs_out.thr_lo_o);
  thr_hi <= signed(regs_out.thr_hi_o);

  trigger_generator_wb_1: trigger_generator_wb
    port map (
      rst_n_i    => rst_n_sys_i,
      clk_sys_i  => clk_sys_i,
      wb_adr_i   => slave_i.adr(3 downto 2),
      wb_dat_i   => slave_i.dat,
      wb_dat_o   => slave_o.dat,
      wb_cyc_i   => slave_i.cyc,
      wb_sel_i   => slave_i.sel,
      wb_stb_i   => slave_i.stb,
      wb_we_i    => slave_i.we,
      wb_ack_o   => slave_o.ack,
      wb_stall_o => slave_o.stall,
      clk_acq_i  => clk_adc_i,
      regs_i     => regs_in,
      regs_o     => regs_out);
  
  p_fsm : process(clk_adc_i)
  begin
    if rising_edge(clk_adc_i) then
      if rst_n_adc_i = '0' or regs_out.csr_enable_o = '0' then
        trig_bus_o              <= (others => '0');
        regs_in.csr_triggered_i <= '0';
        state                   <= IDLE;
      else
        case state is
          when IDLE =>
            trig_bus_o <= (others => '0');
            if(regs_out.csr_arm_o = '1') then
              regs_in.csr_triggered_i <= '0';
              state                   <= ARMED;
            elsif (regs_out.csr_force_o = '1') then
              trig_bus_o              <= regs_out.csr_mask_o;
              regs_in.csr_triggered_i <= '1';
              state                   <= IDLE;
            end if;

          when ARMED =>
            if (regs_out.csr_polarity_o = '0' and x <= thr_lo) or (regs_out.csr_polarity_o = '1' and x >= thr_lo) then
              state <= WAIT_THR_LO;
            end if;

          when WAIT_THR_LO =>
            if (regs_out.csr_polarity_o = '0' and x > thr_lo) or (regs_out.csr_polarity_o = '1' and x < thr_lo) then
              state <= THR_LO_HIT;
            end if;

          when THR_LO_HIT =>
            if (regs_out.csr_polarity_o = '0' and x <= thr_lo) or (regs_out.csr_polarity_o = '1' and x >= thr_lo) then
              state <= ARMED;
            elsif (regs_out.csr_polarity_o = '0' and x > thr_hi) or (regs_out.csr_polarity_o = '1' and x < thr_hi) then
              trig_bus_o              <= regs_out.csr_mask_o;
              regs_in.csr_triggered_i <= '1';
              state                   <= IDLE;
            end if;
            
        end case;
      end if;
    end if;
  end process;





end rtl;



