yosys -ql icesugar.log -p 'synth_ice40 -top icesugar -json icesugar.json' icesugar.v ice40lp1k_spram.v spimemio.v simpleuart.v picosoc.v picorv32.v

nextpnr-ice40 --freq 13 --lp1k --asc icesugar.asc --pcf icesugar.pcf --json icesugar.json --package cm36 --pcf-allow-unconstrained 