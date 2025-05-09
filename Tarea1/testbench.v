`include "maquina.v"
`include "tester.v"

module testbench;

// Senales de entrada
wire clk, reset, PAGO_RECIBIDO;
wire [2:0] tipo_cafe_in;
wire [1:0] tamano_in;
wire [2:0] nivel_azucar_in;

//Senales de salida
wire [3:0] precio;
wire concentracion;
wire leche;
wire espuma;
wire [2:0] nivel_azucar_out;


maquina DUT (
    .clk(clk),
    .reset(rst),
    .tipo_cafe_in(tipo_cafe_in),
    .tamano_in(tamano_in),
    .nivel_azucar_in(nivel_azucar_in),
    .PAGO_RECIBIDO(PAGO_RECIBIDO),
    .precio(precio),
    .concentracion(concentracion),
    .leche(leche),
    .espuma(espuma),
    .nivel_azucar_out(nivel_azucar_out)
);

tester TEST (
    .clk(clk),
    .reset(rst),
    .tipo_cafe_in(tipo_cafe_in),
    .tamano_in(tamano_in),
    .nivel_azucar_in(nivel_azucar_in),
    .PAGO_RECIBIDO(PAGO_RECIBIDO),
    .precio(precio),
    .concentracion(concentracion),
    .leche(leche),
    .espuma(espuma),
    .nivel_azucar_out(nivel_azucar_out)
);


endmodule