module gold_ring (node0_pesi, node0_peri, node0_pedi, node0_peso, node0_pero, node0_pedo, node0_polarity,
                  node1_pesi, node1_peri, node1_pedi, node1_peso, node1_pero, node1_pedo, node1_polarity,
                  node2_pesi, node2_peri, node2_pedi, node2_peso, node2_pero, node2_pedo, node2_polarity,
                  node3_pesi, node3_peri, node3_pedi, node3_peso, node3_pero, node3_pedo, node3_polarity,
                  clk, reset);

    input clk, reset;

    input node0_pesi, node0_pero;
    input [63:0] node0_pedi;
    output node0_peri, node0_peso, node0_polarity;
    output [63:0] node0_pedo;

    input node1_pesi, node1_pero;
    input [63:0] node1_pedi;
    output node1_peri, node1_peso, node1_polarity;
    output [63:0] node1_pedo;

    input node2_pesi, node2_pero;
    input [63:0] node2_pedi;
    output node2_peri, node2_peso, node2_polarity;
    output [63:0] node2_pedo;

    input node3_pesi, node3_pero;
    input [63:0] node3_pedi;
    output node3_peri, node3_peso, node3_polarity;
    output [63:0] node3_pedo;


    wire cwso_0, cwso_1, cwso_2, cwso_3;
    wire ccwso_0, ccwso_1, ccwso_2, ccwso_3;
    wire cwri_0, cwri_1, cwri_2, cwri_3;
    wire ccwri_0, ccwri_1, ccwri_2, ccwri_3;
    wire [63:0] cwdo_0, cwdo_1, cwdo_2, cwdo_3;
    wire [63:0] ccwdo_0, ccwdo_1, ccwdo_2, ccwdo_3;



    gold_router router_0 (cwso_3, cwri_0, cwdo_3, ccwso_1, ccwri_0, ccwdo_1, node0_pesi, node0_peri, node0_pedi,
                          cwso_0, cwri_1, cwdo_0, ccwso_0, ccwri_3, ccwdo_0, node0_peso, node0_pero, node0_pedo,
                          node0_polarity, clk, reset);

    gold_router router_1 (cwso_0, cwri_1, cwdo_0, ccwso_2, ccwri_1, ccwdo_2, node1_pesi, node1_peri, node1_pedi,
                          cwso_1, cwri_2, cwdo_1, ccwso_1, ccwri_0, ccwdo_1, node1_peso, node1_pero, node1_pedo,
                          node1_polarity, clk, reset);

    gold_router router_2 (cwso_1, cwri_2, cwdo_1, ccwso_3, ccwri_2, ccwdo_3, node2_pesi, node2_peri, node2_pedi,
                          cwso_2, cwri_3, cwdo_2, ccwso_2, ccwri_1, ccwdo_2, node2_peso, node2_pero, node2_pedo,
                          node2_polarity, clk, reset);

    gold_router router_3 (cwso_2, cwri_3, cwdo_2, ccwso_0, ccwri_3, ccwdo_0, node3_pesi, node3_peri, node3_pedi,
                          cwso_3, cwri_0, cwdo_3, ccwso_3, ccwri_2, ccwdo_3, node3_peso, node3_pero, node3_pedo,
                          node3_polarity, clk, reset);




endmodule    






