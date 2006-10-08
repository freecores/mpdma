library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity dma_controller_tb is
end dma_controller_tb;

architecture TB_ARCHITECTURE of dma_controller_tb is
	-- Component declaration of the tested unit
	component dma_controller is
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

              BRAM_Rst_0  : OUT STD_LOGIC;
              BRAM_Clk_0  : OUT STD_LOGIC;
              BRAM_Addr_0 : OUT STD_LOGIC_VECTOR(0 TO 31);
              BRAM_EN_0   : OUT STD_LOGIC;
              BRAM_WEN_0  : OUT STD_LOGIC_VECTOR(0 TO 3);
              BRAM_Dout_0 : OUT STD_LOGIC_VECTOR(0 TO 31);
              BRAM_Din_0  : IN  STD_LOGIC_VECTOR(0 TO 31);
          
              BRAM_Rst_1  : OUT STD_LOGIC;
              BRAM_Clk_1  : OUT STD_LOGIC;
              BRAM_Addr_1 : OUT STD_LOGIC_VECTOR(0 TO 31);
              BRAM_EN_1   : OUT STD_LOGIC;
              BRAM_WEN_1  : OUT STD_LOGIC_VECTOR(0 TO 3);
              BRAM_Dout_1 : OUT STD_LOGIC_VECTOR(0 TO 31);
              BRAM_Din_1  : IN  STD_LOGIC_VECTOR(0 TO 31);

              DBG_state : out std_logic_vector(0 to 2);
		DBG_src: out	std_logic_vector(0 to 31);
		DBG_dst: out   std_logic_vector(0 to 31);
		DBG_size: out   std_logic_vector(0 to 31);
		DBG_buffer: out   std_logic_vector(0 to 31)
	);
	end component;

	signal FSL_Clk	: std_logic := '0';
	signal FSL_Rst	: std_logic := '0';
	signal FSL_S_Clk	: std_logic;
	signal FSL_S_Read	: std_logic;
	signal FSL_S_Data	: std_logic_vector(0 to 31) := X"00000000";
	signal FSL_S_Control : std_logic := '0';
	signal FSL_S_Exists	: std_logic := '0';
	signal FSL_M_Clk	: std_logic;
	signal FSL_M_Write	: std_logic;
	signal FSL_M_Data	: std_logic_vector(0 to 31);
	signal FSL_M_Control : std_logic;
	signal FSL_M_Full	: std_logic := '0';

       signal BRAM_Rst_0  : STD_LOGIC;
       signal BRAM_Clk_0  : STD_LOGIC;
       signal BRAM_Addr_0 : STD_LOGIC_VECTOR(0 TO 31);
       signal BRAM_EN_0   : STD_LOGIC;
       signal BRAM_WEN_0  : STD_LOGIC_VECTOR(0 TO 3);
       signal BRAM_Dout_0 : STD_LOGIC_VECTOR(0 TO 31);
       signal BRAM_Din_0  : STD_LOGIC_VECTOR(0 TO 31) := X"00000000";
          
       signal BRAM_Rst_1  : STD_LOGIC;
       signal BRAM_Clk_1  : STD_LOGIC;
       signal BRAM_Addr_1 : STD_LOGIC_VECTOR(0 TO 31);
       signal BRAM_EN_1   : STD_LOGIC;
       signal BRAM_WEN_1  : STD_LOGIC_VECTOR(0 TO 3);
       signal BRAM_Dout_1 : STD_LOGIC_VECTOR(0 TO 31);
       signal BRAM_Din_1  : STD_LOGIC_VECTOR(0 TO 31) := X"00000000";
       
       signal DBG_state : std_logic_vector(0 to 2);
	signal DBG_src: std_logic_vector(0 to 31);
	signal DBG_dst: std_logic_vector(0 to 31);
	signal DBG_size: std_logic_vector(0 to 31);
	signal DBG_buffer: std_logic_vector(0 to 31);

begin

	-- Unit Under Test port map
	UUT : dma_controller

		port map (
       		FSL_Clk	=> FSL_Clk,
       		FSL_Rst	=> FSL_Rst,
       		FSL_S_Clk => FSL_S_Clk,
       		FSL_S_Read => FSL_S_Read,
       		FSL_S_Data => FSL_S_Data,
       		FSL_S_Control => FSL_S_Control,
       		FSL_S_Exists => FSL_S_Exists,
       		FSL_M_Clk => FSL_M_Clk,
       		FSL_M_Write => FSL_M_Write,
       		FSL_M_Data => FSL_M_Data,
       		FSL_M_Control => FSL_M_Control,
       		FSL_M_Full => FSL_M_Full,
       		-- DO NOT EDIT ABOVE THIS LINE ---------------------
       
                     BRAM_Rst_0  => BRAM_Rst_0,
                     BRAM_Clk_0  => BRAM_Clk_0,
                     BRAM_Addr_0 => BRAM_Addr_0, 
                     BRAM_EN_0  => BRAM_EN_0,
                     BRAM_WEN_0 => BRAM_WEN_0,
                     BRAM_Dout_0 => BRAM_Dout_0,
                     BRAM_Din_0 => BRAM_Din_0,
                 
                     BRAM_Rst_1  => BRAM_Rst_1,
                     BRAM_Clk_1  => BRAM_Clk_1,
                     BRAM_Addr_1 => BRAM_Addr_1, 
                     BRAM_EN_1  => BRAM_EN_1,
                     BRAM_WEN_1 => BRAM_WEN_1,
                     BRAM_Dout_1 => BRAM_Dout_1,
                     BRAM_Din_1 => BRAM_Din_1,
                 
       		DBG_state => DBG_state,
      			DBG_src => DBG_src,
       		DBG_dst => DBG_dst,
       		DBG_size => DBG_size,
       		DBG_buffer => DBG_buffer
		);	 
		
	-- Add your stimulus here ...

clock : PROCESS
   begin
   wait for 10 ns; FSL_Clk  <= not FSL_Clk;
end PROCESS clock;

stimulus : PROCESS
   begin
   wait for 25 ns; FSL_Rst <= '1';
   wait for 20 ns; FSL_Rst  <= '0';
   wait;
end PROCESS stimulus;

config : PROCESS
begin
	wait for 110 ns; FSL_S_Data <= X"00000010"; wait for 2 ns; FSL_S_Exists <= '1';
	wait for 20 ns; FSL_S_Data <= X"00000000"; 
	wait for 20 ns; FSL_S_Data <= X"00010000"; 
	wait for 20 ns; FSL_S_Data <= X"00000008"; 
	wait for 42 ns; FSL_S_Exists <= '0';
	wait;
end PROCESS config;

end TB_ARCHITECTURE;


