program Dijkstra;

uses
  SysUtils, DateUtils, Math;

const
  INF = MaxInt;  // Valor de infinito

type
  TEdge = record
    dest: LongInt;  // Cambiado a LongInt
    weight: LongInt; // Cambiado a LongInt
  end;

  TAdjList = array of array of TEdge;
  TDistanceArray = array of LongInt; // Cambiado a LongInt

procedure AddEdge(var adjList: TAdjList; src, dest, weight: LongInt); // Cambiado a LongInt
begin
  SetLength(adjList[src], Length(adjList[src]) + 1);
  adjList[src][High(adjList[src])].dest := dest;
  adjList[src][High(adjList[src])].weight := weight;
end;

function Dijkstra(adjList: TAdjList; startNode, nodeCount: LongInt): TDistanceArray; // Cambiado a LongInt
var
  distances: TDistanceArray;
  visited: array of Boolean;
  currentNode, newDist: LongInt; // Cambiado a LongInt
  edge: TEdge;
  i, j: LongInt; // Cambiado a LongInt
begin
  SetLength(distances, nodeCount);
  SetLength(visited, nodeCount);
  
  for i := 0 to nodeCount - 1 do
  begin
    distances[i] := INF; // Inicializamos las distancias como infinitas
    visited[i] := False;  // Marcamos todos los nodos como no visitados
  end;

  distances[startNode] := 0; // Distancia al nodo de inicio es 0

  for i := 0 to nodeCount - 1 do
  begin
    // Encontrar el nodo no visitado con la distancia mínima
    currentNode := -1;
    for j := 0 to nodeCount - 1 do
    begin
      if (not visited[j]) and ((currentNode = -1) or (distances[j] < distances[currentNode])) then
        currentNode := j;
    end;

    if (currentNode = -1) or (distances[currentNode] = INF) then
      Break; // Todos los nodos visitados o no hay acceso

    visited[currentNode] := True; // Marcar como visitado

    // Procesar cada arista del nodo actual
    for edge in adjList[currentNode] do
    begin
      newDist := distances[currentNode] + edge.weight;

      // Solo actualizamos si encontramos una distancia menor
      if newDist < distances[edge.dest] then
        distances[edge.dest] := newDist; // Actualizar la distancia
    end;
  end;

  Dijkstra := distances;  // Retornar las distancias calculadas
end;

procedure GenerateGraph(var adjList: TAdjList; numNodes, numEdges: LongInt); // Cambiado a LongInt
var
  src, dest, weight, i: LongInt; // Cambiado a LongInt
begin
  SetLength(adjList, numNodes);

  Randomize;

  // Conectar nodos aleatoriamente para evitar nodos aislados
  for i := 0 to numEdges - 1 do
  begin
    src := Random(numNodes);
    dest := Random(numNodes);
    while dest = src do
      dest := Random(numNodes); // Asegurarse de no conectar el nodo a sí mismo
    weight := Random(100) + 1; // Peso aleatorio entre 1 y 100
    AddEdge(adjList, src, dest, weight);
  end;
end;

var
  adjList: TAdjList;
  distances: TDistanceArray;
  numNodes, numEdges: LongInt; // Cambiado a LongInt
  startTime, endTime: TDateTime;
  elapsedMillis: Int64;
begin
  numNodes := 10000;  // 10,000 nodos
  numEdges := 50000;  // 50,000 aristas

  // Generar el grafo
  GenerateGraph(adjList, numNodes, numEdges);

  // Ejecutar Dijkstra
  startTime := Now;  // Capturamos el tiempo de inicio
  distances := Dijkstra(adjList, 0, numNodes);
  endTime := Now;  // Capturamos el tiempo al finalizar

  elapsedMillis := MilliSecondsBetween(startTime, endTime);

  WriteLn('Distancia mínima al último nodo: ', distances[numNodes - 1]);
  WriteLn('Tiempo de ejecución: ', elapsedMillis, ' ms');
end.
