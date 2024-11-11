import java.util.*;

class Nodo implements Comparable<Nodo> {
    int id;
    int distancia;

    public Nodo(int id, int distancia) {
        this.id = id;
        this.distancia = distancia;
    }

    @Override
    public int compareTo(Nodo otro) {
        return Integer.compare(this.distancia, otro.distancia);
    }
}

public class Dijkstra {
    private static final int INF = Integer.MAX_VALUE;
    private Nodo[][] grafo;
    private int[] distancias;
    private int[] tamanioLista; // Para mantener el tamaño de cada lista de adyacencia

    public Dijkstra(int numNodos) {
        grafo = new Nodo[numNodos][];
        distancias = new int[numNodos];
        tamanioLista = new int[numNodos];

        // Inicializamos las distancias y listas de adyacencia
        for (int i = 0; i < numNodos; i++) {
            grafo[i] = new Nodo[numNodos];  // Inicializamos con el tamaño máximo
            distancias[i] = INF;            // Establecemos todas las distancias como infinito
            tamanioLista[i] = 0;            // Inicializamos el tamaño de cada lista a cero
        }
    }

    public void agregarArista(int origen, int destino, int peso) {
        grafo[origen][tamanioLista[origen]++] = new Nodo(destino, peso);
    }

    public void calcularDistancias(int inicio) {
        PriorityQueue<Nodo> pq = new PriorityQueue<>();
        distancias[inicio] = 0;
        pq.add(new Nodo(inicio, 0));

        while (!pq.isEmpty()) {
            Nodo actual = pq.poll();
            int u = actual.id;

            // Si la distancia es mayor que la registrada, la ignoramos
            if (actual.distancia > distancias[u]) {
                continue;
            }

            // Relajación de aristas
            for (int i = 0; i < tamanioLista[u]; i++) {
                Nodo vecino = grafo[u][i];
                int v = vecino.id;
                int peso = vecino.distancia;

                // Si encontramos una distancia más corta hacia 'v'
                if (distancias[u] + peso < distancias[v]) {
                    distancias[v] = distancias[u] + peso;
                    pq.add(new Nodo(v, distancias[v]));
                }
            }
        }
    }

    public int obtenerDistancia(int destino) {
        return distancias[destino] == INF ? -1 : distancias[destino];
    }

    public static void main(String[] args) {
        int numNodos = 10000;
        int numAristas = 50000;

        Dijkstra dijkstra = new Dijkstra(numNodos);

        Random rand = new Random();

        // Agregar aristas aleatorias para simular un grafo grande
        for (int i = 0; i < numAristas; i++) {
            int origen = rand.nextInt(numNodos);
            int destino = rand.nextInt(numNodos);
            int peso = rand.nextInt(100) + 1;  // Peso entre 1 y 100
            dijkstra.agregarArista(origen, destino, peso);
        }

        int inicio = 0;
        long tiempoInicio = System.nanoTime(); // Iniciar el cronómetro

        dijkstra.calcularDistancias(inicio);

        long tiempoFin = System.nanoTime(); // Detener el cronómetro
        double tiempoSegundos = (tiempoFin - tiempoInicio) / 1_000_000.0; // Convertir a milisegundos

        // Imprimir el tiempo de ejecución y la distancia mínima a un nodo específico
        int destino = numNodos - 1;
        System.out.println("Tiempo de ejecución de Dijkstra: " + tiempoSegundos + " milisegundos");
    }
}
