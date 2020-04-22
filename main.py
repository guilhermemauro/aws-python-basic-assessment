import networkx as nx
import matplotlib.pyplot as plt


if __name__ == '__main__':
    MDG = nx.MultiDiGraph()
    MDG.add_nodes_from(["A", "B", "C", "D"])
    MDG.add_edges_from([("A", "B"), ("A", "C"), ("C", "D")])
    nx.draw_networkx(MDG)
    plt.show()