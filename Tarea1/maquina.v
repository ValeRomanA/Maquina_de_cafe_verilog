module maquina (
    input clk,
    input reset,
    input [2:0] tipo_cafe_in,    // 001: Negro, 010: con leche, 011:Espresso, 100: Capuchino
    input [1:0] tamano_in,       // 01: Pequeno, 10: Mediano, 11: Grande
    input [2:0] nivel_azucar_in, // 001:0, 010:1, 011:2, 100:3, 101:4, 110:5
    input PAGO_RECIBIDO,
    output reg [3:0] precio,  //0001: 500, 0010: 1000, 0011: 1500, 0100: 750, 0101: 1250, 0110: 1750, 0111: 2000, 1000: 2250
    output reg concentracion, // 0:Regular, 1:Fuerte
    output reg leche,         // 1: con leche, 0:sin leche
    output reg espuma,        // 1: si, 0: no
    output reg [2:0] nivel_azucar_out

);

// Definicion de estados
localparam 
    SELECCION       = 2'b00,
    MOSTRAR_PRECIO  = 2'b01,
    PREPARAR_BEBIDA = 2'b10,
    TERMINADO       = 2'b11;

// Registros de estado y control
reg [1:0] state, next_state;
reg [6:0] timer;
reg [1:0] ciclos_preparados;
parameter TIMEOUT = 7'd10;

// Registros para almacenar las entradas
reg [2:0] tipo_cafe;
reg [1:0] tamano;
reg [2:0] nivel_azucar;



// Codificacion de precios
always @* begin 
    case({tipo_cafe_in, tamano_in})
        5'b001_01: precio = 4'b0001; // Negro Pequeno: 500
        5'b001_10: precio = 4'b0010; // Negro Mediano: 1000
        5'b001_11: precio = 4'b0011; // Negro Grande: 1500
        5'b010_01: precio = 4'b0100; // Con leche Pequeno: 750
        5'b010_10: precio = 4'b0101; // Con leche Mediano: 1250
        5'b010_11: precio = 4'b0110; // Con leche Grande: 1750
        5'b011_01: precio = 4'b0010; // Espresso Pequeno: 1000
        5'b011_10: precio = 4'b0011; // Espresso Mediano: 1500
        5'b011_11: precio = 4'b0111; // Espresso Grande: 2000
        5'b100_01: precio = 4'b0101; // Capuchino Pequeno: 1250
        5'b100_10: precio = 4'b0110; // Capuchino Mediano: 1750
        5'b100_11: precio = 4'b1000; // Capuchino Grande: 2250
        default:    precio = 4'b0000; // Invalido
    endcase
end

// Logica secuencial
always @(posedge clk ) begin
    if (reset) begin
        state <= SELECCION;
        timer <= 0;
        ciclos_preparados <= 0;
        {concentracion, leche, espuma} <= 3'b000;
        nivel_azucar_out <= 3'b000;
    end else begin
        state <= next_state;

        // Control del temporizador
        if (state == MOSTRAR_PRECIO) begin
        if (timer < TIMEOUT)
            timer <= timer + 1;
        end else begin
            timer<= 0;
        end

        // Control del temporizador
        if (state == PREPARAR_BEBIDA) begin
            if (ciclos_preparados < tamano)
            ciclos_preparados <= ciclos_preparados + 1;
        end else begin
            ciclos_preparados <= 0;
        end

        // Capturamos las entradas SOLO en estado SELECCION
        if (state == SELECCION) begin
            tipo_cafe <= tipo_cafe_in;
            tamano <= tamano_in;
            nivel_azucar <= nivel_azucar_in;
        end
        
        // Al terminar, limpiamos las entradas almacenadas
        if (state == TERMINADO ) begin
            tipo_cafe <= 3'b000;
            tamano <= 2'b00;
            nivel_azucar <= 3'b000;
        end

            
    end
 end


// Maquina de estados - logica combinacional
always @* begin 
    // Valores por defecto
    next_state = state;
    concentracion = 0;
    leche = 0;
    espuma = 0;
    nivel_azucar_out = 3'b000;

    case(state)
        SELECCION: begin
            if ((tipo_cafe >= 3'b001 && tipo_cafe <= 3'b100) && 
                (tamano >= 2'b01 && tamano <= 2'b11) && 
                (nivel_azucar >= 3'b001 && nivel_azucar <= 3'b110))
                next_state = MOSTRAR_PRECIO;
            else
                next_state = SELECCION;
        end

        MOSTRAR_PRECIO: begin
            if (PAGO_RECIBIDO)
                next_state = PREPARAR_BEBIDA;
            else if (timer >= TIMEOUT)
                next_state = SELECCION;   
        end

        PREPARAR_BEBIDA: begin
                // Configuracion de las senales segun tipo de cafe
                case(tipo_cafe)
                    3'b001: {concentracion, leche, espuma} <= 3'b000; // Negro
                    3'b010: {concentracion, leche, espuma} <= 3'b010; // Con leche
                    3'b011: {concentracion, leche, espuma} <= 3'b100; // Espresso
                    3'b100: {concentracion, leche, espuma} <= 3'b111; // Capuchino
                endcase
                nivel_azucar_out <= nivel_azucar;
                if (tamano == 2'b01 && ciclos_preparados >= 0) begin
                            next_state <= TERMINADO;
                end else if (tamano == 2'b10 && ciclos_preparados >= 1) begin
                            next_state <= TERMINADO;
                end else if (tamano == 2'b11 && ciclos_preparados >= 2) begin
                            next_state <= TERMINADO;
            end
        end

        TERMINADO: begin
            {concentracion, leche, espuma} <= 3'b000;
            nivel_azucar_out <= 3'b000;
            next_state = SELECCION;
        end

        default: next_state = SELECCION;
    endcase
end
endmodule