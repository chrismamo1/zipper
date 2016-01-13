all: zipper.native

zipper.native: zipper.ml
	ocamlbuild -package bz2 zipper.native

clean:
	ocamlbuild -clean
