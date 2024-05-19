//input pad
module pc3d01(CIN, PAD);
input PAD;
output CIN;
wire  constant_one, constant_zero;
assign constant_one = 1'b1;
assign constant_zero = 1'b0;
PDDW0204CDG I1( .PAD(PAD), .DS(constant_zero), .OEN(constant_one), .PE(constant_one), .I(constant_zero), .IE(constant_one), .C(CIN) );
endmodule

//output pad 
module pt3o01(PAD, I);
output PAD;
input I;
wire  constant_one, constant_zero;
assign constant_one = 1'b1;
assign constant_zero = 1'b0;
PDDW0204CDG I1( .PAD(PAD), .DS(constant_zero), .OEN(constant_zero), .PE(constant_one), .I(I), .IE(constant_zero), .C() );
endmodule

module pvdc( VDD );
output VDD;
PVDD1CDG I1 ( .VDD(VDD) );
endmodule

module pv0c( VSS );
output VSS;
PVSS1CDG I1 ( .VSS(VSS) );
endmodule

module pvda( );
PVDD2CDG I1 ( );
endmodule

module pv0a( );
PVSS2CDG I1 ( );
endmodule

module ppoc;
PVDD2POC I1 ();
endmodule

module pfrelr;
PCORNER I1 ();
endmodule

module top();
wire wire_clk;
wire [7:0] wire_database_seq_in;
wire wire_flipflop_in;
wire wire_inverter_in;
wire [7:0] wire_query_seq_in;
wire wire_rst_n;
wire wire_scan_en;
wire wire_scan_in1;
wire wire_scan_in2;
wire wire_scan_in3;
wire wire_start;
wire [2:0] wire_database_seq_out;
wire wire_flipflop_out;
wire wire_inverter_out;
wire wire_output_valid;
wire [2:0] wire_query_seq_out;
wire wire_ready;
wire wire_scan_out1;
wire wire_scan_out2;
wire wire_scan_out3;
wire [6:0] wire_score;
wire   net1000;
wire   net1001;


specify
    specparam CDS_LIBNAME  = "testLib";
    specparam CDS_CELLNAME = "top";
    specparam CDS_VIEWNAME = "schematic";
endspecify

sw I0(.clk(wire_clk)
,.database_seq_in(wire_database_seq_in[7:0])
,.flipflop_in(wire_flipflop_in)
,.inverter_in(wire_inverter_in)
,.query_seq_in(wire_query_seq_in[7:0])
,.rst_n(wire_rst_n)
,.scan_en(wire_scan_en)
,.scan_in1(wire_scan_in1)
,.scan_in2(wire_scan_in2)
,.scan_in3(wire_scan_in3)
,.start(wire_start)
,.database_seq_out(wire_database_seq_out[2:0])
,.flipflop_out(wire_flipflop_out)
,.inverter_out(wire_inverter_out)
,.output_valid(wire_output_valid)
,.query_seq_out(wire_query_seq_out[2:0])
,.ready(wire_ready)
,.scan_out1(wire_scan_out1)
,.scan_out2(wire_scan_out2)
,.scan_out3(wire_scan_out3)
,.score(wire_score[6:0])
);



pv0c PAD_G1 (.VSS(VSS));
pv0c PAD_G2 (.VSS(VSS));
pvdc PAD_I1 (.VDD(VDD));
pvdc PAD_I2 (.VDD(VDD));

pvda PAD_G3 ( );
pvda PAD_G4 ( );
pv0a PAD_I3 ( );
pv0a PAD_I4 ( );

ppoc PAD_POC ();


pc3d01 I5 ( .CIN(wire_clk), .PAD(net100));
pc3d01 I6 ( .CIN(wire_database_seq_in[7]), .PAD(net101));
pc3d01 I7 ( .CIN(wire_database_seq_in[6]), .PAD(net102));
pc3d01 I8 ( .CIN(wire_database_seq_in[5]), .PAD(net103));
pc3d01 I9 ( .CIN(wire_database_seq_in[4]), .PAD(net104));
pc3d01 I10 ( .CIN(wire_database_seq_in[3]), .PAD(net105));
pc3d01 I11 ( .CIN(wire_database_seq_in[2]), .PAD(net106));
pc3d01 I12 ( .CIN(wire_database_seq_in[1]), .PAD(net107));
pc3d01 I13 ( .CIN(wire_database_seq_in[0]), .PAD(net108));
pc3d01 I14 ( .CIN(wire_flipflop_in), .PAD(net109));
pc3d01 I15 ( .CIN(wire_inverter_in), .PAD(net110));
pc3d01 I16 ( .CIN(wire_query_seq_in[7]), .PAD(net111));
pc3d01 I17 ( .CIN(wire_query_seq_in[6]), .PAD(net112));
pc3d01 I18 ( .CIN(wire_query_seq_in[5]), .PAD(net113));
pc3d01 I19 ( .CIN(wire_query_seq_in[4]), .PAD(net114));
pc3d01 I20 ( .CIN(wire_query_seq_in[3]), .PAD(net115));
pc3d01 I21 ( .CIN(wire_query_seq_in[2]), .PAD(net116));
pc3d01 I22 ( .CIN(wire_query_seq_in[1]), .PAD(net117));
pc3d01 I23 ( .CIN(wire_query_seq_in[0]), .PAD(net118));
pc3d01 I24 ( .CIN(wire_rst_n), .PAD(net119));
pc3d01 I25 ( .CIN(wire_scan_en), .PAD(net120));
pc3d01 I26 ( .CIN(wire_scan_in1), .PAD(net121));8
pc3d01 I27 ( .CIN(wire_scan_in2), .PAD(net122));
pc3d01 I28 ( .CIN(wire_scan_in3), .PAD(net123));
pc3d01 I29 ( .CIN(wire_start), .PAD(net124));

pt3o01 I30 ( .PAD(net125), .I(wire_database_seq_out[2]));
pt3o01 I31 ( .PAD(net126), .I(wire_database_seq_out[1]));
pt3o01 I32 ( .PAD(net127), .I(wire_database_seq_out[0]));
pt3o01 I33 ( .PAD(net128), .I(wire_flipflop_out));
pt3o01 I34 ( .PAD(net129), .I(wire_inverter_out));
pt3o01 I35 ( .PAD(net130), .I(wire_output_valid));
pt3o01 I36 ( .PAD(net131), .I(wire_query_seq_out[2]));
pt3o01 I37 ( .PAD(net132), .I(wire_query_seq_out[1]));
pt3o01 I38 ( .PAD(net133), .I(wire_query_seq_out[0]));
pt3o01 I39 ( .PAD(net134), .I(wire_ready));
pt3o01 I40 ( .PAD(net135), .I(wire_scan_out1));
pt3o01 I41 ( .PAD(net136), .I(wire_scan_out2));
pt3o01 I42 ( .PAD(net137), .I(wire_scan_out3));
pt3o01 I43 ( .PAD(net138), .I(wire_score[6]));
pt3o01 I44 ( .PAD(net139), .I(wire_score[5]));
pt3o01 I45 ( .PAD(net140), .I(wire_score[4]));
pt3o01 I46 ( .PAD(net141), .I(wire_score[3]));
pt3o01 I47 ( .PAD(net142), .I(wire_score[2]));
pt3o01 I48 ( .PAD(net143), .I(wire_score[1]));
pt3o01 I49 ( .PAD(net144), .I(wire_score[0]));

pfrelr Pcornerlr();
pfrelr Pcornerll();
pfrelr Pcornerur();
pfrelr Pcornerul();

endmodule