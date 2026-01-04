from scad_export import Folder, Model, export

files=Folder(
    name='scad_export/dodecahedron_pot',
    contents=[
        Model(name='pot'),
        Model(name='insert'),
    ]
)

export(files)
