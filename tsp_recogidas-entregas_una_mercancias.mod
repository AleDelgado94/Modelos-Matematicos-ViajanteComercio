/* TSP, Traveling Salesman Problem */


param NCITIES, integer, >=3;
param Q, integer, >0;

set CIUDADES := 1..NCITIES;
set ARC, within CIUDADES cross CIUDADES;

param DISTANCIA{(i,j) in ARC};
param d{i in CIUDADES}, integer;

var x{(i,j) in ARC}, binary; /* VARIABLE indica si el arco (i,j) está en la solución */
var f{(i,j) in ARC};
var f1{(i,j) in ARC};


printf "Resolucion problema TSP con %d ciudades\n", NCITIES;

/* FUNCION OBJETIVO*/
minimize fobjetivo: sum{(i,j) in ARC} DISTANCIA[i,j] * x[i,j];

/* RESTRICCIONES*/
s.t. entrada{i in CIUDADES}: sum{(i,j) in ARC} x[j,i]=1;
s.t. salida{i in CIUDADES}: sum{(i,j) in ARC} x[i,j]=1;

s.t. salida_entrada: sum{(i,j) in ARC: i=1} x[i,j] = sum{(i,j) in ARC: j=1} x[i,j];

s.t. r1{i in CIUDADES: i!=1}: ( sum{(i,j) in ARC} f1[j,i] - sum{(i,j) in ARC} f1[i,j] ) = d[i];
s.t. r3{(i,j) in ARC}: f1[i,j] <=  Q  * x[i,j];
s.t. r4{(i,j) in ARC}: 0 <= f1[i,j];






/* EVITAR SUBTOUR CON VARIABLE f(i,j)*/

s.t. entrasale{i in CIUDADES: i>1}: (sum{(i,j) in ARC: j!=i} f[j,i] - sum{(i,j) in ARC: j!=i} f[i,j]) = 1;
s.t. rest1{(i,j) in ARC: i!=j and i!=1}:f[i,j] >= 0;
s.t. rest2{(i,j) in ARC: i!=j and i!=1}: f[i,j] <= (NCITIES-2)*x[i,j];
s.t. rest3{(1,j) in ARC: j>1}: f[1,j] <= (NCITIES-1)*x[1,j];



solve;

printf "Coste total del tour: %d\n",
   sum{(i,j) in ARC} DISTANCIA[i,j] * x[i,j];
printf("Desde el nodo   al nodo   con coste      y demanda\n");
printf{(i,j) in ARC: x[i,j]} "      %3d       %3d   %8g    %8g\n",
   i, j, DISTANCIA[i,j], d[i];



data;

param NCITIES := 5;

/* GRAFO EJEMPLO*/
param : ARC : DISTANCIA :=
   1	2	10
   1	3	6
   1	4	7
   3	2	2
   3	4	8
   2	5	3
   5	3	1
   4	5	4
   4	1	5
   
   2	1	99999
   3	1	99999
   2	3	99999
   4	3	99999
   5	2	99999
   5	4	99999
   3	5	99999
   
   
;

param Q := 10;
param : d :=
	1	0
	2	2
	3	3
	4	-3
	5	4
	
;
end;