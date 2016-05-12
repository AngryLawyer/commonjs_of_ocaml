# Edit this for your own project dependencies
OPAM_DEPENDS="ocamlfind js_of_ocaml"

case "$OCAML_VERSION,$OPAM_VERSION" in
4.02.3,1.2.2) ppa=avsm/ocaml42+opam12 ;;
4.03.0,1.2.2) ppa=avsm/ocaml42+opam12 ;;
*) echo Unknown $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
esac

echo "yes" | sudo add-apt-repository ppa:$ppa
sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam
export OPAMYES=1
opam init

if [ $OCAML_VERSION = "4.03.0" ]; then
    opam switch set 4.03.0+trunk
fi

opam install ${OPAM_DEPENDS}
eval `opam config env`

ocaml setup.ml -configure --enable-tests
ocaml setup.ml -build
ocaml setup.ml -test
