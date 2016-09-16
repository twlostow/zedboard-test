-- This VHDL was converted from Verilog using the
-- Icarus Verilog VHDL Code Generator 0.9.7  (v0_9_7)

library ieee;
use ieee.std_logic_1164.all;

use work.axi4_pkg.all;


entity xprocessing_system_zedboard is

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

end entity xprocessing_system_zedboard;


architecture wrapper of xprocessing_system_zedboard is

  component processing_system_zedboard is
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
      M_AXI_GP0_ACLK      : in    std_logic;
      M_AXI_GP0_ARADDR    : out   std_logic_vector(31 downto 0);
      M_AXI_GP0_ARBURST   : out   std_logic_vector(1 downto 0);
      M_AXI_GP0_ARCACHE   : out   std_logic_vector(3 downto 0);
      M_AXI_GP0_ARID      : out   std_logic_vector(11 downto 0);
      M_AXI_GP0_ARLEN     : out   std_logic_vector(3 downto 0);
      M_AXI_GP0_ARLOCK    : out   std_logic_vector(1 downto 0);
      M_AXI_GP0_ARPROT    : out   std_logic_vector(2 downto 0);
      M_AXI_GP0_ARQOS     : out   std_logic_vector(3 downto 0);
      M_AXI_GP0_ARREADY   : in    std_logic;
      M_AXI_GP0_ARSIZE    : out   std_logic_vector(2 downto 0);
      M_AXI_GP0_ARVALID   : out   std_logic;
      M_AXI_GP0_AWADDR    : out   std_logic_vector(31 downto 0);
      M_AXI_GP0_AWBURST   : out   std_logic_vector(1 downto 0);
      M_AXI_GP0_AWCACHE   : out   std_logic_vector(3 downto 0);
      M_AXI_GP0_AWID      : out   std_logic_vector(11 downto 0);
      M_AXI_GP0_AWLEN     : out   std_logic_vector(3 downto 0);
      M_AXI_GP0_AWLOCK    : out   std_logic_vector(1 downto 0);
      M_AXI_GP0_AWPROT    : out   std_logic_vector(2 downto 0);
      M_AXI_GP0_AWQOS     : out   std_logic_vector(3 downto 0);
      M_AXI_GP0_AWREADY   : in    std_logic;
      M_AXI_GP0_AWSIZE    : out   std_logic_vector(2 downto 0);
      M_AXI_GP0_AWVALID   : out   std_logic;
      M_AXI_GP0_BID       : in    std_logic_vector(11 downto 0);
      M_AXI_GP0_BREADY    : out   std_logic;
      M_AXI_GP0_BRESP     : in    std_logic_vector(1 downto 0);
      M_AXI_GP0_BVALID    : in    std_logic;
      M_AXI_GP0_RDATA     : in    std_logic_vector(31 downto 0);
      M_AXI_GP0_RID       : in    std_logic_vector(11 downto 0);
      M_AXI_GP0_RLAST     : in    std_logic;
      M_AXI_GP0_RREADY    : out   std_logic;
      M_AXI_GP0_RRESP     : in    std_logic_vector(1 downto 0);
      M_AXI_GP0_RVALID    : in    std_logic;
      M_AXI_GP0_WDATA     : out   std_logic_vector(31 downto 0);
      M_AXI_GP0_WID       : out   std_logic_vector(11 downto 0);
      M_AXI_GP0_WLAST     : out   std_logic;
      M_AXI_GP0_WREADY    : in    std_logic;
      M_AXI_GP0_WSTRB     : out   std_logic_vector(3 downto 0);
      M_AXI_GP0_WVALID    : out   std_logic;
      PS_CLK              : inout std_logic;
      PS_PORB             : inout std_logic;
      PS_SRSTB            : inout std_logic;
      TTC0_WAVE0_OUT      : out   std_logic;
      TTC0_WAVE1_OUT      : out   std_logic;
      TTC0_WAVE2_OUT      : out   std_logic;
      USB0_PORT_INDCTL    : out   std_logic_vector(1 downto 0);
      USB0_VBUS_PWRFAULT  : in    std_logic;
      USB0_VBUS_PWRSELECT : out   std_logic);
  end component processing_system_zedboard;

  signal arid, awid, BID, RID : std_logic_vector(11 downto 0); 
   signal ARVALID, AWVALID : std_logic;                                                    
begin

  U_Wrapped_PS : processing_system_zedboard
    port map (
      DDR_Addr            => DDR_Addr,
      DDR_BankAddr        => DDR_BankAddr,
      DDR_CAS_n           => DDR_CAS_n,
      DDR_CKE             => DDR_CKE,
      DDR_CS_n            => DDR_CS_n,
      DDR_Clk             => DDR_Clk,
      DDR_Clk_n           => DDR_Clk_n,
      DDR_DM              => DDR_DM,
      DDR_DQ              => DDR_DQ,
      DDR_DQS             => DDR_DQS,
      DDR_DQS_n           => DDR_DQS_n,
      DDR_DRSTB           => DDR_DRSTB,
      DDR_ODT             => DDR_ODT,
      DDR_RAS_n           => DDR_RAS_n,
      DDR_VRN             => DDR_VRN,
      DDR_VRP             => DDR_VRP,
      DDR_WEB             => DDR_WEB,
      FCLK_CLK0           => FCLK_CLK0,
      FCLK_RESET0_N       => FCLK_RESET0_N,
      MIO                 => MIO,
      M_AXI_GP0_ACLK      => m_axi_gp0_aclk_i,
      M_AXI_GP0_ARADDR    => m_axi_gp0_o.ARADDR,
      M_AXI_GP0_ARBURST   => open,
      M_AXI_GP0_ARCACHE   => open,
      M_AXI_GP0_ARID      => ARID,
      M_AXI_GP0_ARLEN     => open,
      M_AXI_GP0_ARLOCK    => open,
      M_AXI_GP0_ARPROT    => open,
      M_AXI_GP0_ARQOS     => open,
      M_AXI_GP0_ARREADY   => m_axi_gp0_i.ARREADY,
      M_AXI_GP0_ARSIZE    => open,
      M_AXI_GP0_ARVALID   => ARVALID,
      M_AXI_GP0_AWADDR    => m_axi_gp0_o.AWADDR,
      M_AXI_GP0_AWBURST   => open,
      M_AXI_GP0_AWCACHE   => open,
      M_AXI_GP0_AWID      => AWID,
      M_AXI_GP0_AWLEN     => open,
      M_AXI_GP0_AWLOCK    => open,
      M_AXI_GP0_AWPROT    => open,
      M_AXI_GP0_AWQOS     => open,
      M_AXI_GP0_AWREADY   => m_axi_gp0_i.AWREADY,
      M_AXI_GP0_AWSIZE    => open,
      M_AXI_GP0_AWVALID   => AWVALID,
      M_AXI_GP0_BID       => BID,
      M_AXI_GP0_BREADY    => m_axi_gp0_o.BREADY,
      M_AXI_GP0_BRESP     => m_axi_gp0_i.BRESP,
      M_AXI_GP0_BVALID    => m_axi_gp0_i.BVALID,
      M_AXI_GP0_RDATA     => m_axi_gp0_i.RDATA,
      M_AXI_GP0_RID       => RID,
      M_AXI_GP0_RLAST     => m_axi_gp0_i.RLAST,
      M_AXI_GP0_RREADY    => m_axi_gp0_o.RREADY,
      M_AXI_GP0_RRESP     => m_axi_gp0_i.RRESP,
      M_AXI_GP0_RVALID    => m_axi_gp0_i.RVALID,
      M_AXI_GP0_WDATA     => m_axi_gp0_o.WDATA,
      M_AXI_GP0_WID       => open,
      M_AXI_GP0_WLAST     => m_axi_gp0_o.WLAST,
      M_AXI_GP0_WREADY    => m_axi_gp0_i.WREADY,
      M_AXI_GP0_WSTRB     => m_axi_gp0_o.WSTRB,
      M_AXI_GP0_WVALID    => m_axi_gp0_o.WVALID,
      PS_CLK              => PS_CLK,
      PS_PORB             => PS_PORB,
      PS_SRSTB            => PS_SRSTB,
      TTC0_WAVE0_OUT      => TTC0_WAVE0_OUT,
      TTC0_WAVE1_OUT      => TTC0_WAVE1_OUT,
      TTC0_WAVE2_OUT      => TTC0_WAVE2_OUT,
      USB0_PORT_INDCTL    => USB0_PORT_INDCTL,
      USB0_VBUS_PWRFAULT  => USB0_VBUS_PWRFAULT,
      USB0_VBUS_PWRSELECT => USB0_VBUS_PWRSELECT);


  -- forward transaction IDs to convert to AXI4-Lite
  
  m_axi_gp0_o.ARVALID <= ARVALID;
  m_axi_gp0_o.AWVALID <= AWVALID;

  process(m_axi_gp0_aclk_i)
  begin
    if rising_edge(m_axi_gp0_aclk_i) then
      if ARVALID = '1' then
        rid <= ARID;
      end if;

      if AWVALID = '1' then
        BID <= AWID;
      end if;
    end if;
  end process;

end wrapper;



