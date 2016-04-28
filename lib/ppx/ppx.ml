open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident


let getenv_mapper argv =
  { default_mapper with
    expr = fun mapper expr ->
      match expr with
      | [%expr [%require [%e str]]] ->
          let args = [] in
          Exp.apply ~loc (Exp.ident {txt = Longident.parse "ReactJS.create_element"; loc=expr.pexp.loc}) args
      | x -> default_mapper.expr mapper x;
  }

let () = register "require" require_mapper
