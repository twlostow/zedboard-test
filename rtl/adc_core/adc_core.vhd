library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use work.wishbone_pkg.all;
use work.gencores_pkg.all;
use work.axi4_pkg.all;

entity adc_core is
  port(
    clk_sys_i : in std_logic;
    rst_n_i   : in std_logic;

    adc_dco_p_i : in std_logic;
    adc_dco_n_i : in std_logic;
    adc_fco_p_i : in std_logic;
    adc_fco_n_i : in std_logic;
    adc_d_p_i   : in std_logic_vector(7 downto 0);
    adc_d_n_i   : in std_logic_vector(7 downto 0);

    slave_i : in  t_axi4_lite_slave_in_32;
    slave_o : out t_axi4_lite_slave_out_32;

    led_o : out std_logic
    );
end adc_core;

architecture rtl of adc_core is

  component ad9263_serdes is
    generic (
      SYS_W : integer := 9;
      DEV_W : integer := 72
      );
    port (
      data_in_from_pins_p : in  std_logic_vector(sys_w-1 downto 0);
      data_in_from_pins_n : in  std_logic_vector(sys_w-1 downto 0);
      DATA_IN_TO_DEVICE   : out std_logic_vector(dev_w -1 downto 0);
      bitslip             : in  std_logic_vector(sys_w -1 downto 0) := (others => '0');
      clk_in_p            : in  std_logic;
      clk_in_n            : in  std_logic;

      clk_div_out : out std_logic;
      clk_reset   : in  std_logic;
      io_reset    : in  std_logic);

  end component;


  component bitUnpackAndAlign is
    port (
      rst_n_i           : in  std_logic;
      clk_adc_i         : in  std_logic;
      serdes_data_raw_i : in  std_logic_vector(71 downto 0);
      ch_a_data_o       : out std_logic_vector(15 downto 0);
      ch_b_data_o       : out std_logic_vector(15 downto 0);
      ch_c_data_o       : out std_logic_vector(15 downto 0);
      ch_d_data_o       : out std_logic_vector(15 downto 0);
      bitslip_o         : out std_logic);
  end component bitUnpackAndAlign;

  component xwb_axi4lite_bridge is
    port (
      clk_sys_i    : in  std_logic;
      rst_n_i      : in  std_logic;
      axi4_slave_i : in  t_axi4_lite_slave_in_32;
      axi4_slave_o : out t_axi4_lite_slave_out_32;
      wb_master_o  : out t_wishbone_master_out;
      wb_master_i  : in  t_wishbone_master_in);
  end component xwb_axi4lite_bridge;

  component d3s_acq_buffer is
    generic (
      g_data_width : integer;
      g_size       : integer);
    port (
      rst_n_sys_i : in  std_logic;
      rst_n_acq_i : in  std_logic;
      clk_sys_i   : in  std_logic;
      clk_acq_i   : in  std_logic;
      trigger_i   : in  std_logic;
      data_i      : in  std_logic_vector(g_data_width-1 downto 0);
      slave_i     : in  t_wishbone_slave_in;
      slave_o     : out t_wishbone_slave_out);
  end component d3s_acq_buffer;

  component trigger_generator is
    port (
      clk_adc_i   : in  std_logic;
      clk_sys_i   : in  std_logic;
      rst_n_sys_i : in  std_logic;
      rst_n_adc_i : in  std_logic;
      samples_i   : in  std_logic_vector(15 downto 0);
      slave_i     : in  t_wishbone_slave_in;
      slave_o     : out t_wishbone_slave_out;
      trig_bus_o  : out std_logic_vector(3 downto 0));
  end component trigger_generator;

  -- Number of slave port(s) on the wishbone crossbar
  constant c_NUM_WB_SLAVES : integer := 9;


  constant c_SLAVE_GPIO  : integer := 0;
  constant c_SLAVE_TRIG0 : integer := 1;
  constant c_SLAVE_BUF0  : integer := 2;
  constant c_SLAVE_TRIG1 : integer := 3;
  constant c_SLAVE_BUF1  : integer := 4;
  constant c_SLAVE_TRIG2 : integer := 5;
  constant c_SLAVE_BUF2  : integer := 6;
  constant c_SLAVE_TRIG3 : integer := 7;
  constant c_SLAVE_BUF3  : integer := 8;


  constant c_slave_addr : t_wishbone_address_array(0 to c_NUM_WB_SLAVES-1) :=
    (c_SLAVE_GPIO  => x"00000000",
     c_SLAVE_TRIG0 => x"00001000",
     c_SLAVE_BUF0  => x"00002000",
     c_SLAVE_TRIG1 => x"00003000",
     c_SLAVE_BUF1  => x"00004000",
     c_SLAVE_TRIG2 => x"00005000",
     c_SLAVE_BUF2  => x"00006000",
     c_SLAVE_TRIG3 => x"00007000",
     c_SLAVE_BUF3  => x"00008000"
     );

  constant c_slave_mask : t_wishbone_address_array(0 to c_NUM_WB_SLAVES-1) :=
    (c_SLAVE_GPIO  => x"0000f000",
     c_SLAVE_TRIG0 => x"0000f000",
     c_SLAVE_BUF0  => x"0000f000",
     c_SLAVE_TRIG1 => x"0000f000",
     c_SLAVE_BUF1  => x"0000f000",
     c_SLAVE_TRIG2 => x"0000f000",
     c_SLAVE_BUF2  => x"0000f000",
     c_SLAVE_TRIG3 => x"0000f000",
     c_SLAVE_BUF3  => x"0000f000"
     );

  type t_data_array is array(0 to 3) of std_logic_vector(15 downto 0);
  type t_trigger_array is array(0 to 3) of std_logic_vector(3 downto 0);

  signal ch_data     : t_data_array;
  signal ch_triggers : t_trigger_array;
  signal ch_trigger_ored : std_logic_vector(3 downto 0);
  
  signal serdes_data_raw             : std_logic_vector(71 downto 0);
  signal clk_adc, rst_adc, rst_n_adc : std_logic;
  signal wb_slave_in                 : t_wishbone_slave_in;
  signal wb_slave_out                : t_wishbone_slave_out;

  signal cnx_master_out : t_wishbone_master_out_array(0 to c_NUM_WB_SLAVES-1);
  signal cnx_master_in  : t_wishbone_master_in_array(0 to c_NUM_WB_SLAVES-1);

  signal gpio_out           : std_logic_vector(31 downto 0);
  signal serdes_bitslip     : std_logic;
  signal serdes_bitslip_slv : std_logic_vector(8 downto 0);

  function f_gen_trigger(channel : integer; triggers : t_trigger_array) return std_logic is
  begin
    return triggers(0)(channel) or triggers(1)(channel) or triggers(2)(channel) or triggers(3)(channel);
  end f_gen_trigger;
  signal rst_adc_serdes : std_logic;
  
begin

  xwb_axi4lite_bridge_1 : xwb_axi4lite_bridge
    port map (
      clk_sys_i    => clk_sys_i,
      rst_n_i      => rst_n_i,
      axi4_slave_i => slave_i,
      axi4_slave_o => slave_o,
      wb_master_o  => wb_slave_in,
      wb_master_i  => wb_slave_out);

  U_crossbar : xwb_crossbar
    generic map (
      g_num_masters => 1,
      g_num_slaves  => c_NUM_WB_SLAVES,
      g_registered  => true,
      g_address     => c_slave_addr,
      g_mask        => c_slave_mask)
    port map (
      clk_sys_i  => clk_sys_i,
      rst_n_i    => rst_n_i,
      slave_i(0) => wb_slave_in,
      slave_o(0) => wb_slave_out,
      master_o   => cnx_master_out,
      master_i   => cnx_master_in
      );

  rst_adc_serdes   <= not rst_n_i or gpio_out(1);
  rst_adc   <= not rst_n_i or gpio_out(2);
  rst_n_adc <= not rst_adc;

  U_Serdes : ad9263_serdes
    port map (
      data_in_from_pins_p(8)          => adc_fco_p_i,
      data_in_from_pins_p(7 downto 0) => adc_d_p_i,
      data_in_from_pins_n(8)          => adc_fco_n_i,
      data_in_from_pins_n(7 downto 0) => adc_d_n_i,
      DATA_IN_TO_DEVICE               => serdes_data_raw,
      clk_in_p                        => adc_dco_p_i,
      clk_in_n                        => adc_dco_n_i,
      clk_div_out                     => clk_adc,
      clk_reset                       => rst_adc_serdes,
      io_reset                        => rst_adc_serdes,
      bitslip                         => serdes_bitslip_slv);

  serdes_bitslip_slv <= (others => serdes_bitslip);


  
  U_UnpackAndAlign : bitUnpackAndAlign
    port map (
      rst_n_i           => rst_n_adc,
      clk_adc_i         => clk_adc,
      serdes_data_raw_i => serdes_data_raw,
      ch_a_data_o       => ch_data(0),
      ch_b_data_o       => ch_data(1),
      ch_c_data_o       => ch_data(2),
      ch_d_data_o       => ch_data(3),
      bitslip_o         => serdes_bitslip);

  gen_triggers_and_buffers : for channel in 0 to 3 generate
    
    
    U_trigger_generator_CHx : trigger_generator
      port map (
        clk_adc_i   => clk_adc,
        clk_sys_i   => clk_sys_i,
        rst_n_sys_i => rst_n_i,
        rst_n_adc_i => rst_n_adc,
        samples_i   => ch_data(channel),
        slave_i     => cnx_master_out(c_SLAVE_TRIG0 + 2 * channel),
        slave_o     => cnx_master_in(c_SLAVE_TRIG0 + 2 * channel),
        trig_bus_o  => ch_triggers(channel));


  ch_trigger_ored(channel) <= f_gen_trigger(channel, ch_triggers);
    U_Buf_CHx : d3s_acq_buffer
      generic map (
        g_data_width => 16,
        g_size       => 1024)
      port map (
        rst_n_sys_i => rst_n_i,
        rst_n_acq_i => rst_n_adc,
        clk_sys_i   => clk_sys_i,
        clk_acq_i   => clk_adc,
        data_i      => ch_data(channel),
        trigger_i   => ch_trigger_ored(channel),
        slave_i     => cnx_master_out(c_SLAVE_BUF0 + 2 * channel),
        slave_o     => cnx_master_in(c_SLAVE_BUF0 + 2 * channel));

  end generate gen_triggers_and_buffers;


  xwb_gpio_port_1 : xwb_gpio_port
    generic map (
      g_interface_mode         => PIPELINED,
      g_address_granularity    => BYTE,
      g_num_pins               => 32,
      g_with_builtin_tristates => false)
    port map (
      clk_sys_i  => clk_sys_i,
      rst_n_i    => rst_n_i,
      slave_i    => cnx_master_out(c_SLAVE_GPIO),
      slave_o    => cnx_master_in(c_SLAVE_GPIO),
      gpio_out_o => gpio_out,
      gpio_in_i  => (others => '0'),
      gpio_oen_o => open);

  led_o <= gpio_out(0);
end rtl;

