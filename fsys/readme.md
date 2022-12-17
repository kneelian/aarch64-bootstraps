# ENNKFSYS

The idea behind this filesystem is to implement a fs that is
as simple as possible, can be easily be written to on the host
machine into a file, and be manipulated easily in the kernel
in simple, handwritten assembly code.

The files this filesystem is supposed to handle shouldn't breach
the 32 megabyte limit for the largest. It allows variable size
image files, but I don't expect anything beyond 8192 sectors + 
metadata to ever happen.

The design is simple:
	- the disk is divided into pages or sectors
	- each sector is 512 bytes
	- sectors can contain:
		- special data
		- metadata about files
		- file content
		- bitmap
	- the first sector is special and contains
		- fundamental info about the format
		- info about the disk file
		- pointer to first metadata sector
		- pointer to the bitmap

Unlike the FAT map, the ENNKFSYS bitmap is a *literal* bitmap,
in that each bit represents a single page and nothing else.

The filesystem recognises the concept of a "file" and "folder".
These are kept track of in the metadata blocks. 

A metadata sector contains:
	- pointer to previous sector (2 bytes)
	- pointer to next sector (2 bytes)

A file entry in the metadata sector contains:
	- the file name (8 bytes)
	- file type (2 bytes)
	- the number of first data sector (2 bytes)
	- file id (2 bytes)
	- parent folder id (2 bytes)

The file name and type can be any bytes whatsoever, though the
expectation is that they encode *characters* of some type, in
some encoding. A file must always be contained by some folder
(by default this is the root folder zero), but can contain
no data at all (a pointer to the null sector).

A folder entry in the metadata sector contains:
	- the folder name (8 bytes)
	- number of files (2 bytes)
	- padding (2 bytes)
	- folder id (2 bytes)
	- parent folder id (2 bytes)

There is *no* sanity checking whatsoever: folders can be contained
within their children folders, and can even be their own parents.
A failure of this system is that a folder doesn't know what it contains,
which means that directory trawlers must iterate through all the metadata
sectors.

