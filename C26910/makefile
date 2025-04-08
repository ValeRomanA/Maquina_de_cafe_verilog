build: testbench.v
	clear
	iverilog -o tb.vvp testbench.v
	vvp tb.vvp
	gtkwave maquina.vcd

clean:
	rm *.vvp *.vcd
