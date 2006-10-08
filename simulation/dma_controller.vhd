------------------------------------------------------------------------------
-- dma_controller - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2005 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ** YOU MAY COPY AND MODIFY THESE FILES FOR YOUR OWN INTERNAL USE SOLELY  **
-- ** WITH XILINX PROGRAMMABLE LOGIC DEVICES AND XILINX EDK SYSTEM OR       **
-- ** CREATE IP MODULES SOLELY FOR XILINX PROGRAMMABLE LOGIC DEVICES AND    **
-- ** XILINX EDK SYSTEM. NO RIGHTS ARE GRANTED TO DISTRIBUTE ANY FILES      **
-- ** UNLESS THEY ARE DISTRIBUTED IN XILINX PROGRAMMABLE LOGIC DEVICES.     **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          dma_controller
-- Version:           1.00.a
-- Description:       Example FSL core (VHDL).
-- Date:              Mon Sep 25 16:16:29 2006 (by Create and Import Peripheral Wizard Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------------
--
--
-- Definition of Ports
-- FSL_Clk             : Synchronous clock
-- FSL_Rst           : System reset, should always come from FSL bus
-- FSL_S_Clk       : Slave asynchronous clock
-- FSL_S_Read      : Read signal, requiring next available input to be read
-- FSL_S_Data      : Input data
-- FSL_S_CONTROL   : Control Bit, indicating the input data are control word
-- FSL_S_Exists    : Data Exist Bit, indicating data exist in the input FSL bus
-- FSL_M_Clk       : Master asynchronous clock
-- FSL_M_Write     : Write signal, enabling writing to output FSL bus
-- FSL_M_Data      : Output data
-- FSL_M_Control   : Control Bit, indicating the output data are contol word
-- FSL_M_Full      : Full Bit, indicating output FSL bus is full
--
-------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Entity Section
------------------------------------------------------------------------------

entity dma_controller is
	port 
	(
		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol ports, do not add or delete. 
		FSL_Clk	: in	std_logic;
		FSL_Rst	: in	std_logic;
		FSL_S_Clk	: out	std_logic;
		FSL_S_Read	: out	std_logic;
		FSL_S_Data	: in	std_logic_vector(0 to 31);
		FSL_S_Control	: in	std_logic;
		FSL_S_Exists	: in	std_logic;
		FSL_M_Clk	: out	std_logic;
		FSL_M_Write	: out	std_logic;
		FSL_M_Data	: out	std_logic_vector(0 to 31);
		FSL_M_Control	: out	std_logic;
		FSL_M_Full	: in	std_logic;
		-- DO NOT EDIT ABOVE THIS LINE ---------------------

		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol ports, do not add or delete. 
		FSL_Clk1	: in	std_logic;
		FSL_Rst1	: in	std_logic;
		FSL_S_Clk1	: out	std_logic;
		FSL_S_Read1	: out	std_logic;
		FSL_S_Data1	: in	std_logic_vector(0 to 31);
		FSL_S_Control1	: in	std_logic;
		FSL_S_Exists1	: in	std_logic;
		FSL_M_Clk1	: out	std_logic;
		FSL_M_Write1	: out	std_logic;
		FSL_M_Data1	: out	std_logic_vector(0 to 31);
		FSL_M_Control1	: out	std_logic;
		FSL_M_Full1	: in	std_logic;
		
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
              BRAM_Rst_A  : OUT STD_LOGIC;
              BRAM_Clk_A  : OUT STD_LOGIC;
              BRAM_Addr_A : OUT STD_LOGIC_VECTOR(0 TO 31);
              BRAM_EN_A   : OUT STD_LOGIC;
              BRAM_WEN_A  : OUT STD_LOGIC_VECTOR(0 TO 3);
              BRAM_Dout_A : OUT STD_LOGIC_VECTOR(0 TO 31);
              BRAM_Din_A  : IN  STD_LOGIC_VECTOR(0 TO 31);
          
              BRAM_Rst_B  : OUT STD_LOGIC;
              BRAM_Clk_B  : OUT STD_LOGIC;
              BRAM_Addr_B : OUT STD_LOGIC_VECTOR(0 TO 31);
              BRAM_EN_B   : OUT STD_LOGIC;
              BRAM_WEN_B  : OUT STD_LOGIC_VECTOR(0 TO 3);
              BRAM_Dout_B : OUT STD_LOGIC_VECTOR(0 TO 31);
              BRAM_Din_B  : IN  STD_LOGIC_VECTOR(0 TO 31);

              DBG_state : out std_logic_vector(0 to 2);
		DBG_src: out	std_logic_vector(0 to 31);
		DBG_dst: out   std_logic_vector(0 to 31);
		DBG_size: out   std_logic_vector(0 to 31);
		DBG_buffer: out   std_logic_vector(0 to 31)
	);

attribute SIGIS : string; 
attribute SIGIS of FSL_Clk : signal is "Clk"; 
attribute SIGIS of FSL_S_Clk : signal is "Clk"; 
attribute SIGIS of FSL_M_Clk : signal is "Clk"; 
attribute SIGIS of FSL_Clk1 : signal is "Clk"; 
attribute SIGIS of FSL_S_Clk1 : signal is "Clk"; 
attribute SIGIS of FSL_M_Clk1 : signal is "Clk"; 

end dma_controller;

architecture EXAMPLE of dma_controller is

   -- Total number of input data.
   constant NUMBER_OF_INPUT_WORDS  : natural := 4;

   -- Total number of output data
   constant NUMBER_OF_OUTPUT_WORDS : natural := 8;

   type STATE_TYPE is (Idle, Read_Inputss, Running0, Running, Write_Output);

   signal state        : std_logic_vector(0 to 2);

   -- Accumulator to hold sum of inputs read at any point in time
   signal sum          : std_logic_vector(0 to 31);

   signal src : std_logic_vector(0 to 31);
   signal dst : std_logic_vector(0 to 31);
   signal size :   std_logic_vector(0 to 31);

   signal buffer0 : std_logic_vector(0 to 31);

   signal running0_cycle_count : std_logic_vector(0 to 3);


   -- Counters to store the number inputs read & outputs written
   signal nr_of_reads  : natural range 0 to NUMBER_OF_INPUT_WORDS - 1;
   signal nr_of_writes : natural range 0 to NUMBER_OF_OUTPUT_WORDS - 1;

begin
   -- CAUTION:
   -- The sequence in which data are read in and written out should be
   -- consistant with the sequence they are written and read in the
   -- driver's dma_controller.c file

   FSL_S_Read  <= FSL_S_Exists   when state = B"001"   else '0';
   FSL_M_Write <= not FSL_M_Full when state = B"100"  else '0';

   FSL_S_Read1  <= '0'; 
   FSL_M_Write1 <= not FSL_M_Full1 when state = B"100" else '0';

   FSL_M_Data <= src;

   BRAM_Rst_A <= '0';
   BRAM_Rst_B <= '0';
   BRAM_Clk_A <= FSL_Clk;
   BRAM_Clk_B <= FSL_Clk;
   BRAM_ADDR_A <= src;
   BRAM_ADDR_B <= dst;

   DBG_src <= src;
   DBG_dst <= dst;
   DBG_size <= size;
   DBG_buffer <= buffer0;
   DBG_state <= state;
		
   BRAM_Dout_B <= buffer0;

   The_SW_accelerator : process (FSL_Clk) is
   begin  
   	   
    if FSL_Clk'event and FSL_Clk = '1' then     
      if FSL_Rst = '1' then               
        state        <= B"000";
        nr_of_reads  <= 0;
        nr_of_writes <= 0;
        src          <= (others => '0');
        dst          <= (others => '0');
        size          <= (others => '0');
      else
        case state is
          when B"000" =>
            BRAM_EN_A   <= '0';
	     BRAM_EN_B   <= '0';
            if (FSL_S_Exists = '1') then
              state       <= B"001";
              nr_of_reads <= NUMBER_OF_INPUT_WORDS - 1;
              src          <= (others => '0');
              dst          <= (others => '0');
              size          <= (others => '0');
            end if;


          when B"001" =>
            BRAM_WEN_A <= B"0000";
            BRAM_WEN_B <= B"0000";

            if (FSL_S_Exists = '1') then
            	if (nr_of_reads = 3) then 
            		src <= FSL_S_Data; 
   			FSL_M_Data1 <= FSL_S_Data;
            	end if;
            	if (nr_of_reads = 2) then dst <= FSL_S_Data; end if;
            	if (nr_of_reads = 1) then size <= FSL_S_Data; end if;
            	
              if (nr_of_reads = 0) then
                state        <= B"010";
                BRAM_EN_A   <= '1';
                BRAM_EN_B   <= '0';
                running0_cycle_count <= B"0000";
            else
               BRAM_EN_A   <= '0';
               BRAM_EN_B   <= '0';
               nr_of_reads <= nr_of_reads - 1;
              end if;
            end if;

	   when B"010" =>
             BRAM_EN_A   <= '1';
	      src <= std_logic_vector(unsigned(src) + 4);
	      buffer0 <= BRAM_Din_A;
	      running0_cycle_count <= std_logic_vector(unsigned(running0_cycle_count) + 1);
	      if (running0_cycle_count = B"0001") then
	      		state <= B"011";
                     BRAM_WEN_B <= B"1111";
                     BRAM_EN_B   <= '1';
             else 
                     BRAM_WEN_B <= B"0000";
                     BRAM_EN_B  <= '0';
	      	end if;
	   
	   when B"011" =>

	      src <= std_logic_vector(unsigned(src) + 4);
	      dst <= std_logic_vector(unsigned(dst) + 4);
	      size <= std_logic_vector(unsigned(size) - 4);

              if (size = X"00000004") then 
              	state <= B"100";
                    BRAM_EN_A   <= '0';
                    BRAM_EN_B   <= '0';
       	      BRAM_WEN_A <= B"0000";
       	      buffer0 <= BRAM_Din_A;
       	      BRAM_WEN_B <= B"0000";
              else 
                    BRAM_EN_A  <= '1';
                    BRAM_EN_B  <= '1';
       	      BRAM_WEN_A <= B"0000";
       	      buffer0 <= BRAM_Din_A;
       	      BRAM_WEN_B <= B"1111";
              end if;
	   
          when B"100" =>
              BRAM_EN_A   <= '0';
              BRAM_EN_B   <= '0';
              BRAM_WEN_A <= B"0000";
              BRAM_WEN_B <= B"0000";
         	state <= B"000";

          when others =>
          	state <= B"000";

        end case;
      end if;
    end if;
   end process The_SW_accelerator;
end architecture EXAMPLE;
