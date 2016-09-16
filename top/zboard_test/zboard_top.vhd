library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

use work.axi4_pkg.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity zboard_top is
  port (
    DDR_addr          : inout std_logic_vector (14 downto 0);
    DDR_ba            : inout std_logic_vector (2 downto 0);
    DDR_cas_n         : inout std_logic;
    DDR_ck_n          : inout std_logic;
    DDR_ck_p          : inout std_logic;
    DDR_cke           : inout std_logic;
    DDR_cs_n          : inout std_logic;
    DDR_dm            : inout std_logic_vector (3 downto 0);
    DDR_dq            : inout std_logic_vector (31 downto 0);
    DDR_dqs_n         : inout std_logic_vector (3 downto 0);
    DDR_dqs_p         : inout std_logic_vector (3 downto 0);
    DDR_odt           : inout std_logic;
    DDR_ras_n         : inout std_logic;
    DDR_reset_n       : inout std_logic;
    DDR_we_n          : inout std_logic;
    FIXED_IO_ddr_vrn  : inout std_logic;
    FIXED_IO_ddr_vrp  : inout std_logic;
    FIXED_IO_mio      : inout std_logic_vector (53 downto 0);
    FIXED_IO_ps_clk   : inout std_logic;
    FIXED_IO_ps_porb  : inout std_logic;
    FIXED_IO_ps_srstb : inout std_logic;

    adc_dco_p_i : in std_logic;
    adc_dco_n_i : in std_logic;
    adc_fco_p_i : in std_logic;
    adc_fco_n_i : in std_logic;
    adc_d_p_i   : in std_logic_vector(7 downto 0);
    adc_d_n_i   : in std_logic_vector(7 downto 0);


    led_o : out std_logic
    );
end zboard_top;

architecture rtl of zboard_top is

  component xprocessing_system_zedboard is
    port (
      DDR_Addr            : inout std_logic_vector(14 downto 0);
      DDR_BankAddr        : inout std_logic_vector(2 downto 0);
      DDR_CAS_n           : inout std_logic;
      DDR_CKE             : inout std_logic;
      DDR_CS_n            : inout std_logic;
      DDR_Clk             : inout std_logic;
      DDR_Clk_n           : inout std_logic;
      DDR_DM              : inout std_logic_vector(3 downto 0);
      DDR_DQ              : inout std_logic_vector(31 downto 0);
      DDR_DQS             : inout std_logic_vector(3 downto 0);
      DDR_DQS_n           : inout std_logic_vector(3 downto 0);
      DDR_DRSTB           : inout std_logic;
      DDR_ODT             : inout std_logic;
      DDR_RAS_n           : inout std_logic;
      DDR_VRN             : inout std_logic;
      DDR_VRP             : inout std_logic;
      DDR_WEB             : inout std_logic;
      FCLK_CLK0           : out   std_logic;
      FCLK_RESET0_N       : out   std_logic;
      MIO                 : inout std_logic_vector(53 downto 0);
      m_axi_gp0_aclk_i    : in    std_logic;
      m_axi_gp0_o         : out   t_axi4_lite_master_out_32;
      m_axi_gp0_i         : in    t_axi4_lite_master_in_32;
      PS_CLK              : inout std_logic;
      PS_PORB             : inout std_logic;
      PS_SRSTB            : inout std_logic;
      TTC0_WAVE0_OUT      : out   std_logic;
      TTC0_WAVE1_OUT      : out   std_logic;
      TTC0_WAVE2_OUT      : out   std_logic;
      USB0_PORT_INDCTL    : out   std_logic_vector(1 downto 0);
      USB0_VBUS_PWRFAULT  : in    std_logic;
      USB0_VBUS_PWRSELECT : out   std_logic);
  end component xprocessing_system_zedboard;

  signal counter                  : unsigned(31 downto 0);
  signal fclk_clk0, fclk_reset0_n : std_logic;
  signal m_axi_gp0_out            : t_axi4_lite_master_out_32;
  signal m_axi_gp0_in             : t_axi4_lite_master_in_32;

  component ila_0 is
    port(
      clk     : in std_logic;
      probe0  : in std_logic_vector(0 downto 0);
      probe1  : in std_logic_vector(31 downto 0);
      probe2  : in std_logic_vector(1 downto 0);
      probe3  : in std_logic_vector(0 downto 0);
      probe4  : in std_logic_vector(0 downto 0);
      probe5  : in std_logic_vector(31 downto 0);
      probe6  : in std_logic_vector(0 downto 0);
      probe7  : in std_logic_vector(0 downto 0);
      probe8  : in std_logic_vector(0 downto 0);
      probe9  : in std_logic_vector(0 downto 0);
      probe10 : in std_logic_vector(31 downto 0);
      probe11 : in std_logic_vector(0 downto 0);
      probe12 : in std_logic_vector(0 downto 0);
      probe13 : in std_logic_vector(1 downto 0);
      probe14 : in std_logic_vector(31 downto 0);
      probe15 : in std_logic_vector(3 downto 0);
      probe16 : in std_logic_vector(0 downto 0);
      probe17 : in std_logic_vector(2 downto 0);
      probe18 : in std_logic_vector(2 downto 0)
      );

  end component;

  
begin

  xprocessing_system_zedboard_1 : entity work.xprocessing_system_zedboard
    port map (
      DDR_Addr            => DDR_Addr,
      DDR_BankAddr        => DDR_ba,
      DDR_CAS_n           => DDR_CAS_n,
      DDR_CKE             => DDR_CKE,
      DDR_CS_n            => DDR_CS_n,
      DDR_Clk             => DDR_Ck_p,
      DDR_Clk_n           => DDR_Ck_n,
      DDR_DM              => DDR_DM,
      DDR_DQ              => DDR_DQ,
      DDR_DQS             => DDR_DQS_p,
      DDR_DQS_n           => DDR_DQS_n,
      DDR_DRSTB           => DDR_reset_n,
      DDR_ODT             => DDR_ODT,
      DDR_RAS_n           => DDR_RAS_n,
      DDR_VRN             => FIXED_IO_ddr_vrn,
      DDR_VRP             => FIXED_IO_ddr_vrp,
      DDR_WEB             => DDR_WE_n,
      FCLK_CLK0           => FCLK_CLK0,
      FCLK_RESET0_N       => FCLK_RESET0_N,
      MIO                 => FIXED_IO_mio,
      m_axi_gp0_aclk_i    => fclk_clk0,
      m_axi_gp0_o         => m_axi_gp0_out,
      m_axi_gp0_i         => m_axi_gp0_in,
      PS_CLK              => FIXED_IO_ps_clk,
      PS_PORB             => FIXED_IO_ps_porb,
      PS_SRSTB            => FIXED_IO_ps_srstb,
      TTC0_WAVE0_OUT      => open,
      TTC0_WAVE1_OUT      => open,
      TTC0_WAVE2_OUT      => open,
      USB0_PORT_INDCTL    => open,
      USB0_VBUS_PWRFAULT  => '0',
      USB0_VBUS_PWRSELECT => open);

  adc_core_1 : entity work.adc_core
    port map (
      clk_sys_i   => fclk_clk0,
      rst_n_i     => FCLK_RESET0_N,
      adc_dco_p_i => adc_dco_p_i,
      adc_dco_n_i => adc_dco_n_i,
      adc_fco_p_i => adc_fco_p_i,
      adc_fco_n_i => adc_fco_n_i,
      adc_d_p_i   => adc_d_p_i,
      adc_d_n_i   => adc_d_n_i,
      slave_i     => m_axi_gp0_out,
      slave_o     => m_axi_gp0_in,
      led_o       => led_o);

  ila_0_1 : ila_0
    port map (
      clk => FCLK_CLK0,

      probe0(0)  => m_axi_gp0_out.AWVALID,
      probe1  => m_axi_gp0_out.AWADDR,
      probe2  => m_axi_gp0_in.BRESP,
      probe3(0)   => m_axi_gp0_out.ARVALID,
      probe4(0)   => m_axi_gp0_out.BREADY,
      probe5  => m_axi_gp0_out.ARADDR,
      probe6(0)   => m_axi_gp0_out.RREADY,
      probe7(0)   => m_axi_gp0_out.WLAST,
      probe8(0)   => m_axi_gp0_out.WVALID,
      probe9(0)   => m_axi_gp0_in.ARREADY,
      probe10 => m_axi_gp0_out.WDATA,
      probe11(0)  => m_axi_gp0_in.AWREADY,
      probe12(0)  => m_axi_gp0_in.BVALID,
      probe13 => m_axi_gp0_in.RRESP,
      probe14 => m_axi_gp0_in.RDATA,
      probe15 => m_axi_gp0_out.WSTRB,
      probe16(0)  => m_axi_gp0_in.RVALID,
      probe17 => "000",
      probe18 => "000"
      );


end rtl;




