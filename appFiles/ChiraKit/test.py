import numpy as np

matrix_1 = np.loadtxt("/Users/oburastero/Downloads/F_matrix_chirakit.csv", delimiter=",")
matrix_2 = np.loadtxt("/Users/oburastero/Downloads/F_matrix.csv", delimiter=",")

#
mat_dif = matrix_1 - matrix_2
print("Max difference:", np.max(np.abs(mat_dif)))
