using System;
using System.Collections.Generic;
using System.Diagnostics;

class Program
{
    const int INF = int.MaxValue;

    public class Graph
    {
        private int nodes;
        private List<(int dest, int weight)>[] edges;

        public Graph(int nodes)
        {
            this.nodes = nodes;
            edges = new List<(int dest, int weight)>[nodes];
            for (int i = 0; i < nodes; i++)
            {
                edges[i] = new List<(int dest, int weight)>();
            }
        }

        public void AddEdge(int src, int dest, int weight)
        {
            edges[src].Add((dest, weight));
        }

        public int[] Dijkstra(int start)
        {
            int[] distances = new int[nodes];
            bool[] visited = new bool[nodes];
            for (int i = 0; i < nodes; i++)
            {
                distances[i] = INF;
                visited[i] = false;
            }
            distances[start] = 0;

            // Min-heap (Priority Queue)
            SortedSet<(int distance, int vertex)> minHeap = new SortedSet<(int, int)>();
            minHeap.Add((0, start));

            while (minHeap.Count > 0)
            {
                var (currentDistance, currentNode) = minHeap.Min;
                minHeap.Remove(minHeap.Min);
                if (visited[currentNode]) continue;
                visited[currentNode] = true;

                foreach (var (neighbor, weight) in edges[currentNode])
                {
                    if (visited[neighbor]) continue;
                    int newDist = currentDistance + weight;

                    if (newDist < distances[neighbor])
                    {
                        distances[neighbor] = newDist;
                        minHeap.Add((newDist, neighbor));
                    }
                }
            }

            return distances;
        }
    }

    static void Main(string[] args)
    {
        int numNodes = 10000; // Número de nodos
        int numEdges = 50000; // Número de aristas
        Random rand = new Random();
        Graph g = new Graph(numNodes);

        for (int i = 0; i < numEdges; i++)
        {
            int src = rand.Next(numNodes);
            int dest = rand.Next(numNodes);
            int weight = rand.Next(1, 101); // Peso aleatorio entre 1 y 100
            g.AddEdge(src, dest, weight);
        }

        Stopwatch stopwatch = Stopwatch.StartNew();
        int[] distances = g.Dijkstra(0); // Calcular distancias desde el nodo 0
        stopwatch.Stop();

        Console.WriteLine($"Distancia mínima al nodo {numNodes - 1}: {distances[numNodes - 1]}");
        Console.WriteLine($"Tiempo de ejecución de Dijkstra: {stopwatch.ElapsedMilliseconds} ms");
    }
}
