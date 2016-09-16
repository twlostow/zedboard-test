library ieee;
use ieee.std_logic_1164.all;

package axi4_pkg is

  -- AXI4-Full interface, master output ports, 32 bits
  type t_axi4_full_master_out_32 is record
    ARVALID : std_logic;
    AWVALID : std_logic;
    BREADY  : std_logic;
    RREADY  : std_logic;
    WLAST   : std_logic;
    WVALID  : std_logic;
    ARID    : std_logic_vector (11 downto 0);
    AWID    : std_logic_vector (11 downto 0);
    WID     : std_logic_vector (11 downto 0);
    ARBURST : std_logic_vector (1 downto 0);
    ARLOCK  : std_logic_vector (1 downto 0);
    ARSIZE  : std_logic_vector (2 downto 0);
    AWBURST : std_logic_vector (1 downto 0);
    AWLOCK  : std_logic_vector (1 downto 0);
    AWSIZE  : std_logic_vector (2 downto 0);
    ARPROT  : std_logic_vector (2 downto 0);
    AWPROT  : std_logic_vector (2 downto 0);
    ARADDR  : std_logic_vector (31 downto 0);
    AWADDR  : std_logic_vector (31 downto 0);
    WDATA   : std_logic_vector (31 downto 0);
    ARCACHE : std_logic_vector (3 downto 0);
    ARLEN   : std_logic_vector (3 downto 0);
    ARQOS   : std_logic_vector (3 downto 0);
    AWCACHE : std_logic_vector (3 downto 0);
    AWLEN   : std_logic_vector (3 downto 0);
    AWQOS   : std_logic_vector (3 downto 0);
    WSTRB   : std_logic_vector (3 downto 0);
  end record;

  -- AXI4-Full interface, master input ports, 32 bits
  type t_axi4_full_master_in_32 is record
    ARREADY : std_logic;
    AWREADY : std_logic;
    BVALID  : std_logic;
    RLAST   : std_logic;
    RVALID  : std_logic;
    WREADY  : std_logic;
    BID     : std_logic_vector (11 downto 0);
    RID     : std_logic_vector (11 downto 0);
    BRESP   : std_logic_vector (1 downto 0);
    RRESP   : std_logic_vector (1 downto 0);
    RDATA   : std_logic_vector (31 downto 0);
  end record;

  -- AXI4-Lite interface, master output ports, 32 bits
  type t_axi4_lite_master_out_32 is record
    ARVALID : std_logic;
    AWVALID : std_logic;
    BREADY  : std_logic;
    RREADY  : std_logic;
    WLAST   : std_logic;
    WVALID  : std_logic;
    ARADDR  : std_logic_vector (31 downto 0);
    AWADDR  : std_logic_vector (31 downto 0);
    WDATA   : std_logic_vector (31 downto 0);
    WSTRB   : std_logic_vector (3 downto 0);
  end record;

  -- AXI4-Lite interface, master input ports, 32 bits
  type t_axi4_lite_master_in_32 is record
    ARREADY : std_logic;
    AWREADY : std_logic;
    BVALID  : std_logic;
    RLAST   : std_logic;
    RVALID  : std_logic;
    WREADY  : std_logic;
    BRESP   : std_logic_vector (1 downto 0);
    RRESP   : std_logic_vector (1 downto 0);
    RDATA   : std_logic_vector (31 downto 0);
  end record;

  constant c_axi4_lite_default_master_in_32 : t_axi4_lite_master_in_32 :=
    (
      AWREADY => '0',
      ARREADY => '0',
      BVALID  => '0',
      RLAST   => '0',
      RVALID  => '0',
      WREADY  => '0',
      BRESP   => "00",
      RRESP   => "00",
      RDATA   => (others => '0')
      );


  constant c_axi4_lite_default_master_out_32 : t_axi4_lite_master_out_32 :=
    (
      ARVALID => '0',
      AWVALID => '0',
      BREADY  => '0',
      RREADY  => '0',
      WLAST   => '0',
      WVALID  => '0',
      ARADDR  => (others => '0'),
      AWADDR  => (others => '0'),
      WDATA   => (others => '0'),
      WSTRB   => (others => '0')
      );



  subtype t_axi4_lite_slave_in_32 is t_axi4_lite_master_out_32;
  subtype t_axi4_lite_slave_out_32 is t_axi4_lite_master_in_32;

  constant c_AXI4_RESP_OKAY   : std_logic_vector(1 downto 0) := "00";
  constant c_AXI4_RESP_EXOKAY : std_logic_vector(1 downto 0) := "01";
  constant c_AXI4_RESP_SLVERR : std_logic_vector(1 downto 0) := "10";
  constant c_AXI4_RESP_DECERR : std_logic_vector(1 downto 0) := "11";

    function f_axi4_full_to_lite (
    f : t_axi4_full_master_out_32
    )  return t_axi4_lite_master_out_32;
  
  function f_axi4_lite_to_full (
    l : t_axi4_lite_master_in_32
    )  return t_axi4_full_master_in_32;

end package;

package body axi4_pkg is

    function f_axi4_full_to_lite (
    f : t_axi4_full_master_out_32
    )  return t_axi4_lite_master_out_32 is
    variable l : t_axi4_lite_master_out_32;
  begin

    l.ARVALID := f.ARVALID;
    l.AWVALID := f.AWVALID;
    l.BREADY  := f.BREADY;
    l.RREADY  := f.RREADY;
    l.WLAST   := f.WLAST;
    l.WVALID  := f.WVALID;
    l.ARADDR  := f.ARADDR;
    l.AWADDR  := f.AWADDR;
    l.WDATA   := f.WDATA;
    l.WSTRB   := f.WSTRB;

    return l;
    
  end f_axi4_full_to_lite;

  function f_axi4_lite_to_full (
    l : t_axi4_lite_master_in_32
    )  return t_axi4_full_master_in_32 is
    variable f : t_axi4_full_master_in_32;
  begin
    f.ARREADY := l.ARREADY;
    f.AWREADY := l.AWREADY;
    f.BVALID  := l.BVALID;
    f.RLAST   := l.RLAST;
    f.RVALID  := l.RVALID;
    f.WREADY  := l.WREADY;
    f.BID     := (others => '0');
    f.RID     := (others => '0');
    f.BRESP   := l.BRESP;
    f.RRESP   := l.RRESP;
    f.RDATA   := l.RDATA;

    return f;
    
  end f_axi4_lite_to_full;


end package body;
