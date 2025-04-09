module tester(
   output reg clk,
   output reg reset,
   output reg [2:0] tipo_cafe_in, //00: Negro, 01: con leche, 10:Espresso, 11: Capuchino
   output reg [1:0] tamano_in, //00: Pequeno, 01: Mediano, 10: Grande
   output reg [2:0] nivel_azucar_in, //000: 0, 001: 1, 010: 2, 011: 3, 100: 4, 101:5
   output reg PAGO_RECIBIDO,
   input [3:0] precio, //000: 500, 001: 1000, 010: 1500, 011: 750, 100: 1250, 101: 1750, 110: 2000, 111: 2250
   input concentracion, 
   input  leche, 
   input  espuma, 
   input [2:0] nivel_azucar_out //000: 0, 001: 1, 010: 2, 011: 3, 100: 4, 101:5
 
);

// Generar la señal de reloj
    always begin 
        #3 clk = !clk;
    end

initial begin
    //Reset incial
    #3
    clk = 0;
    #3
    reset = 1;
    tipo_cafe_in = 3'b000;
    tamano_in = 2'b00;
    nivel_azucar_in = 3'b000;
    PAGO_RECIBIDO = 0;
    #3
    reset = 0;




   // (Cafe con capucchino, grande, azucar: 5 )
    tipo_cafe_in = 3'b100;
    #6
    tamano_in = 2'b11;
    #6
    nivel_azucar_in = 3'b110;
    #6
    PAGO_RECIBIDO = 1'b1;
    #30
    tipo_cafe_in = 3'b00;
    tamano_in = 2'b00;
    nivel_azucar_in = 3'b000;
    PAGO_RECIBIDO = 0;
    #3



    //(Cafe con leche, mediano, azucar 5)

    tipo_cafe_in = 3'b010;
    #6
    tamano_in = 2'b10;
    #6
    nivel_azucar_in = 3'b110;
    #6
    PAGO_RECIBIDO = 1'b1;
    #30
    tipo_cafe_in = 3'b00;
    tamano_in = 2'b00;
    nivel_azucar_in = 3'b000;
    PAGO_RECIBIDO = 0;
    #30


     #18 $finish;

end



initial begin
	$dumpfile("maquina.vcd");
	$dumpvars();
end

endmodule