/*********************************************
 * OPL 12.6.3.0 Model
 * Author: EZ50bucks
 * Creation Date: Apr 25, 2016 at 11:28:26 AM
 *********************************************/


int n=...;
int alpha=...;
//int k=...;
float beta=...;
int cap=...;
int d=...;
int BER_range=...;

range points=1..n;
range Rows = 1..n;
range Cols = 1..3;
range alpha1= 1..alpha;
range BER1=1..BER_range;
range D1=1..d;
range D2=1..3;

float D[D1][D2]=...;
float BER[BER1]=...; 		//phan luu du lieu doc tu database
float A[Rows][Cols] = ...;

// generate data

tuple location {
	float x;
	float y;
	float z;
}
tuple edge {
	float i;
	float j;
}

string topo_file_name=...;
string result_file_name=...;

setof (edge) edges = {<i,j> | i,j in points : i!=j}; //taocaccanh
//float c[edges]; //khoangcachcaccanh
float value_BER[edges]; //loicaccanh
location pointLocation[points];
int count;
float time_before_read;
float time_after_read;
float time_done;

execute {
	var before = new Date();
	time_before_read = before.getTime();
//	function getDistance (point1,point2){
//		return Opl.sqrt(Opl.pow(point1.x-point2.x,2)+Opl.pow(point1.y-point2.y,2)+Opl.pow(point1.z-point2.z,2)); //tinhkhoangcach
//	}
	
	for (var i in points){	
		pointLocation[i].x=A[i][1]; 
		pointLocation[i].y=A[i][2];	
		pointLocation[i].z=A[i][3];	
	}
	
//	for (var e in edges){
//		c[e]=getDistance(pointLocation[e.i],pointLocation[e.j]);
//	}
	 
	// Tinh BER
	count = 0;
	for (var e in edges){					
			count = count + 1;			
				value_BER[e]= BER[count];
	}
	
	time_after_read = before.getTime();
}	


//decision variable
dvar boolean x[edges];
dvar boolean x1[alpha1][edges][edges];
dvar float+ f[alpha1][edges][edges];

//expression
//dexpr float Total = sum (i in points, j in points: i!=j) (x[<i,j>] + value_BER[<i,j>]);
dexpr float Total = sum (i in points, j in points: i!=j) (x[<i,j>]);

minimize Total;

subject to {
	
	// loai bo cac canh co BER(e)=1
	
	forall (e in edges){
		if (value_BER[e]==1)
		{
			x[e]==0;
			forall (st in edges, alpha in alpha1)
			  {
				x1[alpha][st][e]==0;
				f[alpha][st][e]==0;
  			}	
   		}  						
	}

	forall (g in D1){	
	  flow_out:
	  sum (j in points : j!=D[g][1] && alpha in alpha1) (f[alpha][<D[g][1],D[g][2]>][<D[g][1],j>] - f[alpha][<D[g][1],D[g][2]>][<j,D[g][1]>]) == D[g][3];

//	forall (g in D1)
	  flow_in:
	  sum (i in points : i!=D[g][2] && alpha in alpha1) (f[alpha][<D[g][1],D[g][2]>][<i,D[g][2]>] - f[alpha][<D[g][1],D[g][2]>][<D[g][2],i>]) == D[g][3];
	  
	forall (k in points)
	  if ((k!= D[g][2]) && (k!= D[g][1])){
	 any_point:
	  sum (i in points : i!=k ) f[alpha][<D[g][1],D[g][2]>][<i,k>] == sum (j in points :j!=k) f[alpha][<D[g][1],D[g][2]>][<k,j>];
		}		
 }	
 	forall (i in points, j in points) // tinh cap > tong bang thong theo 2 chieu (i,j) va (j,i)
 	  if (i!=j){
 	sum (alpha in alpha1, g in D1 ) (f[alpha][<D[g][1],D[g][2]>][<i,j>]) <= cap;
} 	
 	  
	forall (i in points, j in points, alpha in alpha1, g in D1){
	  if (i!=j)
	  x1[alpha][<D[g][1],D[g][2]>][<i,j>] >= (f[alpha][<D[g][1],D[g][2]>][<i,j>])/D[g][3]; 
 	}	  	  
	
	forall (i in points, j in points, g in D1) {
	  if (i!=j){
  		x[<i,j>] >= 1.0/D[g][3] * sum (alpha in alpha1) ((x1[alpha][<D[g][1],D[g][2]>][<i,j>]) + x1[alpha][<D[g][1],D[g][2]>][<j,i>]);
      }
    }      
       
	forall (g in D1, alpha in alpha1)
     condition_ber:
     sum (e in edges : value_BER[e] !=1) (log(1-value_BER[e])*x1[alpha][<D[g][1],D[g][2]>][e]) >= log(1-beta);
      
      
     //sum (i in points, j in points : (i!=j) && (value_BER[<i,j>] !=1)) (log(1-value_BER[<i,j>])*x1[alpha][<D[g][1],D[g][2]>][<i,j>]) >= log(1-beta);

	
//    forall (i in points, j in points)
//      if (i!=j){
//      sum (i in points, j in points) pow(log(1-value_BER[<i,j>]),-1) <=  pow(log(1-beta),-1);
  	
} 
	
tuple resultx1 {
	edge st;
	edge ij;
	float z;
}
{edge} results = {<i,j> | i in points, j in points : i != j};

{edge} finalresult = {a | a in results : x[a]==true};
//{edge} finalresultx1 = {a | a in results : x1[alpha][a]==true};

{resultx1} finalres = { <st,ij,f[alpha][st][ij]> | st in results, ij in results : f[alpha][st][ij]!=0 };

execute {
var wfile = new IloOplOutputFile(result_file_name);
var topofile = new IloOplOutputFile(topo_file_name);
var sfile = new IloOplOutputFile("ILPsynthesis.txt", true);
writeln("result_file_name", result_file_name);
writeln("topo_file_name",topo_file_name);
  wfile.writeln("Ket qua duong di:");

wfile.writeln(finalres);
for (var e in finalresult )
{
	var tong_bw_e=0;
	for (var st in results)
		tong_bw_e=tong_bw_e + f[alpha][st][e];
	wfile.writeln(e, "\t", tong_bw_e);
}
wfile.writeln("Ket qua topo");
wfile.writeln(finalresult);
writeln("Ghi topo");
topofile.writeln("Number of edges in topo:")
topofile.writeln(finalresult.size);
topofile.writeln("Toa do cac canh <x1, y1, z1>, <x2, y2, z2>:");
for (var e in finalresult)
	{
		topofile.writeln(pointLocation[e.i].x,"\t", pointLocation[e.i].y, "\t", pointLocation[e.i].z,"\t", pointLocation[e.j].x,"\t", pointLocation[e.j].y,"\t", pointLocation[e.j].z);
		writeln(pointLocation[e.i].x,"\t", pointLocation[e.i].y, "\t", pointLocation[e.i].z,"\t", pointLocation[e.j].x,"\t", pointLocation[e.j].y,"\t", pointLocation[e.j].z);
	}
topofile.close();
wfile.writeln("END Ket qua topo");
var sum =0
var sum_edge=0 
	for (var ij in edges){ 
		if (x[ij]!=0){ 
			sum = sum + value_BER[ij]
			sum_edge = sum_edge + x[ij];
		}		
	}


sfile.write(topo_file_name, "\t");	
wfile.writeln("Tong BER" ," = ", sum/2);
wfile.writeln("Tong so link" ," = ", sum_edge/2);
sfile.write("Tong so link = ", sum_edge/2, "\t");
sfile.write("Tong BER=", sum/2, "\t"); 

wfile.writeln("Ma tran yeu cau")

	for(g in D1) {
	wfile.writeln(D[g]);
	}
		
	var after = new Date();
  	time_done = after.getTime();
  	wfile.writeln("Time read: ");
  	wfile.writeln(time_after_read - time_before_read);
  	wfile.writeln( "Time process:");
  	wfile.writeln(time_done - time_after_read);
  	sfile.writeln("Time process=", time_done - time_after_read);
  	
  	wfile.close();
  	sfile.close();
}



main {


   //var source = new IloOplModelSource("FSOtopoILP.mod");
   
  //  var data = new IloOplDataSource("../../input_output_Topo/Final_programk2m5D5.dat");
  // var data = new IloOplDataSource("../../input_output_Topo/Final_programk2m6D7.dat");
  
 // var data = new IloOplDataSource("../../input_output_Topo/Final_programk2.5m7D10.dat");
  //  var data = new IloOplDataSource("../../input_output_Topo/Final_programk2.5m8D14.dat");
 //  var data = new IloOplDataSource("../../input_output_Topo/Final_programk3m9D18.dat");
  // var data = new IloOplDataSource("../../input_output_Topo/Final_programk3m10D11.dat");
 // var data = new IloOplDataSource("../../input_output_Topo/Final_programk3m10D22.dat");
  // not found var data = new IloOplDataSource("../../input_output_Topo/Final_programk4M16D30.dat");
 //  var data = new IloOplDataSource("Final_programk3m12.dat");
  // var data = new IloOplDataSource("Final_programk4m20.dat");
  //var data = new IloOplDataSource("../../input_output_Topo/Final_programk4m20D40.dat");
  
 //  var data = new IloOplDataSource("../../input_output_Topo/Final_programk3M10D10.dat");
 //  var data = new IloOplDataSource("../../input_output_Topo/Final_programk3M10D15.dat");
  // var data = new IloOplDataSource("../../input_output_Topo/Final_programk3M10D20.dat");
 //  var data = new IloOplDataSource("../../input_output_Topo/Final_programk3M10D25.dat");
  // var data = new IloOplDataSource("../../input_output_Topo/Final_programk3M10D30.dat");
  // var data = new IloOplDataSource("../../input_output_Topo/Final_programk3M10D35.dat");
  // var data = new IloOplDataSource("../../input_output_Topo/Final_programk3M10D40.dat");
   var data = new IloOplDataSource("../../input_output_Topo/Final_programk3M10D45.dat");
  // inputnodes_Set_13p_k3M10D45
  
  //var source = new IloOplModelSource("FSOtopoILP.mod");

   var cplex = new IloCplex();
   var i=0;
   var opl = new IloOplModel(thisOplModel.modelDefinition,cplex);
   
   opl.addDataSource(data);
   opl.generate();
   
	if ( cplex.solve() ) {
		var curr = cplex.getObjValue();
		writeln();
		writeln("OBJECTIVE: ",curr);
		opl.postProcess();
	}
	else {
		writeln("No solution!");
		}
	opl.end();
	data.end();
	cplex.end(); 

}		
