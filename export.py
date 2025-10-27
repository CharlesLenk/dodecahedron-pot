from scad_export.export import export
from scad_export.exportable import Folder, Model

files=Folder(
    name='scad_export/dodecahedron_pot',
    contents=[
        Model(name='pot'),
        Model(name='insert'),
    ]
)

export(files)
