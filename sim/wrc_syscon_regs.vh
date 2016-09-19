`define ADDR_SYSC_RSTR                 5'h0
`define SYSC_RSTR_TRIG_OFFSET 0
`define SYSC_RSTR_TRIG 32'h0fffffff
`define SYSC_RSTR_RST_OFFSET 28
`define SYSC_RSTR_RST 32'h10000000
`define ADDR_SYSC_GPSR                 5'h4
`define SYSC_GPSR_LED_STAT_OFFSET 0
`define SYSC_GPSR_LED_STAT 32'h00000001
`define SYSC_GPSR_LED_LINK_OFFSET 1
`define SYSC_GPSR_LED_LINK 32'h00000002
`define SYSC_GPSR_FMC_SCL_OFFSET 2
`define SYSC_GPSR_FMC_SCL 32'h00000004
`define SYSC_GPSR_FMC_SDA_OFFSET 3
`define SYSC_GPSR_FMC_SDA 32'h00000008
`define SYSC_GPSR_NET_RST_OFFSET 4
`define SYSC_GPSR_NET_RST 32'h00000010
`define SYSC_GPSR_BTN1_OFFSET 5
`define SYSC_GPSR_BTN1 32'h00000020
`define SYSC_GPSR_BTN2_OFFSET 6
`define SYSC_GPSR_BTN2 32'h00000040
`define SYSC_GPSR_SFP_DET_OFFSET 7
`define SYSC_GPSR_SFP_DET 32'h00000080
`define SYSC_GPSR_SFP_SCL_OFFSET 8
`define SYSC_GPSR_SFP_SCL 32'h00000100
`define SYSC_GPSR_SFP_SDA_OFFSET 9
`define SYSC_GPSR_SFP_SDA 32'h00000200
`define SYSC_GPSR_SPI_SCLK_OFFSET 10
`define SYSC_GPSR_SPI_SCLK 32'h00000400
`define SYSC_GPSR_SPI_NCS_OFFSET 11
`define SYSC_GPSR_SPI_NCS 32'h00000800
`define SYSC_GPSR_SPI_MOSI_OFFSET 12
`define SYSC_GPSR_SPI_MOSI 32'h00001000
`define SYSC_GPSR_SPI_MISO_OFFSET 13
`define SYSC_GPSR_SPI_MISO 32'h00002000
`define ADDR_SYSC_GPCR                 5'h8
`define SYSC_GPCR_LED_STAT_OFFSET 0
`define SYSC_GPCR_LED_STAT 32'h00000001
`define SYSC_GPCR_LED_LINK_OFFSET 1
`define SYSC_GPCR_LED_LINK 32'h00000002
`define SYSC_GPCR_FMC_SCL_OFFSET 2
`define SYSC_GPCR_FMC_SCL 32'h00000004
`define SYSC_GPCR_FMC_SDA_OFFSET 3
`define SYSC_GPCR_FMC_SDA 32'h00000008
`define SYSC_GPCR_SFP_SCL_OFFSET 8
`define SYSC_GPCR_SFP_SCL 32'h00000100
`define SYSC_GPCR_SFP_SDA_OFFSET 9
`define SYSC_GPCR_SFP_SDA 32'h00000200
`define SYSC_GPCR_SPI_SCLK_OFFSET 10
`define SYSC_GPCR_SPI_SCLK 32'h00000400
`define SYSC_GPCR_SPI_CS_OFFSET 11
`define SYSC_GPCR_SPI_CS 32'h00000800
`define SYSC_GPCR_SPI_MOSI_OFFSET 12
`define SYSC_GPCR_SPI_MOSI 32'h00001000
`define ADDR_SYSC_HWFR                 5'hc
`define SYSC_HWFR_MEMSIZE_OFFSET 0
`define SYSC_HWFR_MEMSIZE 32'h0000000f
`define ADDR_SYSC_TCR                  5'h10
`define SYSC_TCR_TDIV_OFFSET 0
`define SYSC_TCR_TDIV 32'h00000fff
`define SYSC_TCR_ENABLE_OFFSET 31
`define SYSC_TCR_ENABLE 32'h80000000
`define ADDR_SYSC_TVR                  5'h14