#!/bin/sh
# Automatically generates a PLL parameterized by output freq
# (instead of cryptic parameters)

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 FPGA_KIND INPUTFREQ" >&2
  exit 1
fi

FPGA_KIND=$1
INPUTFREQ=$2

echo "/* "
echo " * Do not edit this file, it was generated by gen_pll.sh"
echo " * "
echo " *   FPGA kind      : $1"
echo " *   Input frequency: $2 MHz"
echo " */"

case $FPGA_KIND in
   "ICE40")
      cat << EOF

 module femtoPLL #(
    parameter freq = 40
 ) (
    input wire pclk,
    output wire clk
 );
   SB_PLL40_CORE pll (
      .REFERENCECLK(pclk),
      .PLLOUTCORE(clk),
      .RESETB(1'b1),
      .BYPASS(1'b0)
   );
   defparam pll.FEEDBACK_PATH="SIMPLE";
   defparam pll.PLLOUT_SELECT="GENCLK";
   generate
     case(freq)
EOF
      for OUTPUTFREQ in `cat frequencies.txt`
      do
        echo "     $OUTPUTFREQ: begin"
        icepll -i $INPUTFREQ -o $OUTPUTFREQ \
	    | egrep "DIVR|DIVF|DIVQ|FILTER_RANGE" \
	    | sed -e 's|[:()]||g' \
	    | awk '{printf("      defparam pll.%s = %s;\n",$1,$3);}'
        echo "     end"
      done
      cat <<EOF
     default: UNKNOWN_FREQUENCY unknown_frequency();
     endcase
  endgenerate   

endmodule  
EOF
      ;;
   "ECP5")
      cat << EOF

 module femtoPLL #(
    parameter freq = 40
 ) (
    input wire pclk,
    output wire clk
 );
(* ICP_CURRENT="12" *) (* LPF_RESISTOR="8" *) (* MFG_ENABLE_FILTEROPAMP="1" *) (* MFG_GMCREF_SEL="2" *)
    EHXPLLL pll_i (
        .RST(1'b0),
        .STDBY(1'b0),
        .CLKI(pclk),
        .CLKOP(clk),
        .CLKFB(clk),
        .CLKINTFB(),
        .PHASESEL0(1'b0),
        .PHASESEL1(1'b0),
        .PHASEDIR(1'b1),
        .PHASESTEP(1'b1),
        .PHASELOADREG(1'b1),
        .PLLWAKESYNC(1'b0),
        .ENCLKOP(1'b0)
   );
   defparam pll_i.PLLRST_ENA = "DISABLED";
   defparam pll_i.INTFB_WAKE = "DISABLED";
   defparam pll_i.STDBY_ENABLE = "DISABLED";
   defparam pll_i.DPHASE_SOURCE = "DISABLED";
   defparam pll_i.OUTDIVIDER_MUXA = "DIVA";
   defparam pll_i.OUTDIVIDER_MUXB = "DIVB";
   defparam pll_i.OUTDIVIDER_MUXC = "DIVC";
   defparam pll_i.OUTDIVIDER_MUXD = "DIVD";
   defparam pll_i.CLKOP_ENABLE = "ENABLED";
   defparam pll_i.CLKOP_FPHASE = 0;
   defparam pll_i.FEEDBK_PATH = "CLKOP";
   generate
     case(freq)
EOF
      for OUTPUTFREQ in `cat frequencies.txt`
      do
          echo "     $OUTPUTFREQ: begin"
	  ecppll -i $INPUTFREQ -o $OUTPUTFREQ -f tmp.v > tmp.txt
          cat tmp.v \
	      | egrep "CLKI_DIV|CLKOP_DIV|CLKOP_CPHASE|CLKFB_DIV" \
	      | sed -e 's|[),.]| |g' -e 's|(|=|g' \
	      | awk '{printf("      defparam pll_i.%s;\n",$1);}'
	  rm -f tmp.v tmp.txt
        echo "     end"
      done
      cat <<EOF
     default: UNKNOWN_FREQUENCY unknown_frequency();
     endcase
   endgenerate
endmodule  
EOF
      ;;
   *)
      echo FPGA_KIND needs to be one of ICE40,ECP5
      exit 1
      ;;
esac