def cif_to_pdb(cif_file, pdb_file):
    with open(cif_file) as f:
        lines = f.readlines()

    # Find start of atom_site loop
    start = None
    for i, line in enumerate(lines):
        if "_atom_site." in line:
            start = i
            break

    if start is None:
        raise ValueError("No _atom_site loop found in CIF file.")

    # Collect column names
    cols = []
    i = start
    while lines[i].strip().startswith("_atom_site."):
        cols.append(lines[i].strip())
        i += 1

    # Find indices of needed fields
    def idx(name):
        return cols.index(f"_atom_site.{name}")

    x_i = idx("Cartn_x")
    y_i = idx("Cartn_y")
    z_i = idx("Cartn_z")
    atom_i = idx("label_atom_id")
    res_i = idx("label_comp_id")
    chain_i = idx("label_asym_id")
    seq_i = idx("label_seq_id")
    elem_i = idx("type_symbol")
    hetatm_i = idx("group_PDB")

    # Read atom records
    atoms = []
    while i < len(lines) and lines[i].strip():
        parts = lines[i].split()
        atoms.append(parts)
        i += 1

    # Write PDB
    with open(pdb_file, "w") as out:
        for n, a in enumerate(atoms, start=1):

            if len(a) < 10:
                break

            x, y, z = a[x_i], a[y_i], a[z_i]
            atom = a[atom_i]
            res = a[res_i]
            chain = a[chain_i]
            seq = a[seq_i]
            elem = a[elem_i]

            hetatm = a[hetatm_i]

            # parse coordinates
            try:
                xf = float(x); yf = float(y); zf = float(z)
            except (ValueError, TypeError):
                continue  # skip malformed coordinate lines

            # if seq is not an integer, skip this atom
            try:
                int(seq)
            except ValueError:
                continue

            # if this is a HETATM,skip it
            if hetatm == "HETATM":
                continue

            line = (
                f"ATOM  {n:5d} {atom:<4} {res:>3} {chain}{int(seq):4d}    "
                f"{float(x):8.3f}{float(y):8.3f}{float(z):8.3f}  1.00  0.00           {elem:>2}\n"
            )

            out.write(line)

        out.write("END\n")