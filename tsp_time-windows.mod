  /* TSP, Traveling Salesman Problem CON VENTANAS TEMPORALES */


param NCITIES, integer, >=3;
param BigM := 1000;

set CIUDADES := 1..NCITIES;
set ARC, within CIUDADES cross CIUDADES;


param DISTANCIA{(i,j) in ARC}; /* COSTO de cada ARCO*/
param e{i in CIUDADES}; /* earliest time */
param l{i in CIUDADES}; /* lastest time */
param t{(i,j) in ARC}; /* TIEMPO */
param s{i in CIUDADES}; /* TIEMPO de SERVICIO*/


/* VARIABLE */
var x{(i,j) in ARC}, binary; /* VARIABLE indica si el arco (i,j) está en la solución */
var f{(i,j) in ARC}; /* CANTIDAD que va por el arco (i,j) */
var u{i in CIUDADES}; /* INSTANTE de TIEMPO de COMIENZO de servicio a "i" */

printf "Resolucion problema TSP con ventanas de tiempo con %d ciudades\n", NCITIES;

/* FUNCION OBJETIVO*/
minimize fobjetivo: sum{(i,j) in ARC} DISTANCIA[i,j] * x[i,j];

/* RESTRICCIONES*/
s.t. entrada{i in CIUDADES}: sum{(i,j) in ARC} x[j,i]=1;

s.t. salida{i in CIUDADES}: sum{(i,j) in ARC} x[i,j]=1;

s.t. tiempo1{i in CIUDADES}: e[i] <= u[i];

s.t. tiempo2{i in CIUDADES}: u[i] <= l[i];

s.t. r1{(i,j) in ARC: j!=1}: u[j] >= u[i] + (s[i] + t[i,j]) * x[i,j] - BigM * (1 - x[i,j]);


/* EVITAR SUBTOUR CON VARIABLE f(i,j)*/
s.t. entrasale{i in CIUDADES: i>1}: (sum{(i,j) in ARC: j!=i} f[j,i] - sum{(i,j) in ARC: j!=i} f[i,j]) = 1;
s.t. rest1{(i,j) in ARC: i!=j and i!=1}:f[i,j] >= 0;
s.t. rest2{(i,j) in ARC: i!=j and i!=1}: f[i,j] <= (NCITIES-2)*x[i,j];
s.t. rest3{(1,j) in ARC: j>1}: f[1,j] <= (NCITIES-1)*x[1,j];



solve;

printf "Coste total:  %d\n",
   sum{(i,j) in ARC} DISTANCIA[i,j] * x[i,j];
printf("Desde el nodo   al nodo   con coste     en el instante\n");
printf{(i,j) in ARC: x[i,j]} "      %3d       %3d   %8g       %8d\n",
   i, j, DISTANCIA[i,j], u[i];



data;

param NCITIES := 10;

/* GRAFO EJEMPLO*/
param : ARC : DISTANCIA , t :=
    1	2	8,1
	1	3	5,2
	1	8	90,1
	1	9	30,3 
	2	3	7,1
	2	4	12,4
	4	5	27,1
	4	3	14,7
	5	7	13,1
	6	5	5,1
	7	6	24,1
	7	8	52,1
	8	3	40,2
	8	9	20,1
	9	10	5,3
	10	1	2,1
	
	2	1	8,1
	3	1	5,1
	8	1	90,4
	9	1	30,1
	3	2	7,1
	4	2	12,1
	5	4	27,1
	3	4	14,1
	7	5	13,1
	5	6	5,1
	6	7	24,1
	8	7	52,1
	3	8	40,1
	9	8	20,1
	10	9	5,1
	1	10	2,1
;




/* VENTANA TEMPORAL */

param  e :=
		1	1
		2	18
		3	5
		4	4
		5	8
		6	1
		7	2
		8	1
		9	3
		10	1
	;

param  l :=

	1	20
	2	19
	3	20
	4	20
	5	14
	6	15
	7	14
	8	20
	9	20
	10	5
	;
	

	
param  s :=
	1	1
	2	1
	3	2
	4	1
	5	1
	6	1
	7	2
	8	1
	9	1
	10	1
	;
end;
