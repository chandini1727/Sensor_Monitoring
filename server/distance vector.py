class Router:
    def __init__(self, name):
        self.name = name
        
        self.distance_vector = {name: (name, 0)}
        self.neighbors = {}  
    
    def add_neighbor(self, neighbor, cost):
        self.neighbors[neighbor] = cost
        
        self.distance_vector[neighbor.name] = (neighbor.name, cost)
    
    def update_distance_vector(self):
        updated = False
        for neighbor, cost_to_neighbor in self.neighbors.items():
           
            for destination, (next_hop, cost_from_neighbor) in neighbor.distance_vector.items():
               
                new_cost = cost_to_neighbor + cost_from_neighbor
                
               
                if destination not in self.distance_vector or new_cost < self.distance_vector[destination][1]:
                    self.distance_vector[destination] = (neighbor.name, new_cost)
                    updated = True
        return updated
    
    def __str__(self):
        result = f"Router {self.name} Distance Vector Table:\n"
        for destination, (next_hop, cost) in self.distance_vector.items():
            result += f"Destination: {destination}, Next Hop: {next_hop}, Cost: {cost}\n"
        return result
A = Router("A")
B = Router("B")
C = Router("C")
D = Router("D")
A.add_neighbor(B, 1)
A.add_neighbor(C, 4)
B.add_neighbor(A, 1)
B.add_neighbor(C, 2)
B.add_neighbor(D, 5)
C.add_neighbor(A, 4)
C.add_neighbor(B, 2)
C.add_neighbor(D, 1)
D.add_neighbor(B, 5)
D.add_neighbor(C, 1)

def simulate_dvr(routers):
    converged = False
    while not converged:
        converged = True
        for router in routers:
            if router.update_distance_vector():
                converged = False

routers = [A, B, C, D]

simulate_dvr(routers)

for router in routers:
    print(router)
