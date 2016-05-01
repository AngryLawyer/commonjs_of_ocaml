open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident

let make_require_string str =
    Printf.sprintf "require('%s')" str

let require_mapper argv =
  { default_mapper with
    expr = fun mapper expr ->
      match expr with
      | [%expr [%require [%e? str]]] ->
          begin 
              match str with
              | { pexp_desc = Pexp_constant (Const_string (s, None)) } ->
                  let req = make_require_string s in
                  let args = [("", (Exp.constant (Const_string (req, None))))] in
                  Exp.apply ~loc:expr.pexp_loc (Exp.ident {txt = Longident.parse "Js.Unsafe.js_expr"; loc=expr.pexp_loc}) args
              | _ ->
                raise (Location.Error (
                    Location.error ~loc:expr.pexp_loc "[%require] expected a constant string"))
          end

      | x -> default_mapper.expr mapper x;
  }

let () = register "require" require_mapper
