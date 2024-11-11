package main

import (
	"container/heap"
	"fmt"
	"math"
	"math/rand"
	"time"
)

const INF = math.MaxInt32
const MAX_NODES = 10000 // Define un número fijo de nodos

// Estructura para el nodo
type Node struct {
	index    int
	distance int
}

// Cola de prioridad (min-heap)
type PriorityQueue []*Node

func (pq PriorityQueue) Len() int           { return len(pq) }
func (pq PriorityQueue) Less(i, j int) bool { return pq[i].distance < pq[j].distance }
func (pq PriorityQueue) Swap(i, j int)      { pq[i], pq[j] = pq[j], pq[i] }

func (pq *PriorityQueue) Push(x interface{}) {
	*pq = append(*pq, x.(*Node))
}

func (pq *PriorityQueue) Pop() interface{} {
	old := *pq
	n := len(old)
	x := old[n-1]
	*pq = old[0 : n-1]
	return x
}

// Estructura del grafo
type Graph struct {
	nodes int
	edges [MAX_NODES][MAX_NODES]int
}

// Crear un nuevo grafo
func NewGraph(n int) *Graph {
	g := &Graph{
		nodes: n,
	}
	for i := 0; i < n; i++ {
		for j := 0; j < n; j++ {
			g.edges[i][j] = 0
		}
	}
	return g
}

// Agregar una arista
func (g *Graph) AddEdge(src, dest, weight int) {
	g.edges[src][dest] = weight
}

// Implementación de Dijkstra
func (g *Graph) Dijkstra(start int) []int {
	distances := make([]int, g.nodes)
	for i := range distances {
		distances[i] = INF
	}
	distances[start] = 0

	pq := &PriorityQueue{}
	heap.Push(pq, &Node{index: start, distance: 0})

	for pq.Len() > 0 {
		currentNode := heap.Pop(pq).(*Node)

		for neighbor := 0; neighbor < g.nodes; neighbor++ {
			if g.edges[currentNode.index][neighbor] > 0 {
				newDist := distances[currentNode.index] + g.edges[currentNode.index][neighbor]
				if newDist < distances[neighbor] {
					distances[neighbor] = newDist
					heap.Push(pq, &Node{index: neighbor, distance: newDist})
				}
			}
		}
	}
	return distances
}

// Función principal
func main() {
	numNodes := 10000 // Número de nodos
	numEdges := 50000 // Número de aristas
	g := NewGraph(numNodes)

	rand.Seed(time.Now().UnixNano())
	for i := 0; i < numEdges; i++ {
		src := rand.Intn(numNodes)
		dest := rand.Intn(numNodes)
		weight := rand.Intn(100) + 1 // Peso aleatorio entre 1 y 100
		g.AddEdge(src, dest, weight)
	}

	startTime := time.Now()
	distances := g.Dijkstra(0) // Calcular distancias desde el nodo 0
	duration := time.Since(startTime)

	fmt.Printf("Distancia mínima al nodo %d: %d\n", numNodes-1, distances[numNodes-1])
	fmt.Printf("Tiempo de ejecución de Dijkstra: %v ms\n", duration.Milliseconds())
}
