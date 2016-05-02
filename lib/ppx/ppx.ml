open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident

let make_require_string str =
    Printf.sprintf "require('%s')" str

let make_args str =
    [("", (Exp.constant (Const_string (str, None))))]

let make_apply loc args =
  Exp.apply ~loc:loc (Exp.ident {txt = Longident.parse "Js.Unsafe.js_expr"; loc=loc}) args

let require_mapper argv =
  { default_mapper with
    expr = fun mapper expr ->
      match expr with
      | [%expr [%require [%e? str]]] ->
          begin 
              match str with
              | { pexp_desc = Pexp_constant (Const_string (s, None)) } ->
                  let args = make_args (make_require_string s) in
                  make_apply expr.pexp_loc args
              | _ ->
                raise (Location.Error (
                    Location.error ~loc:expr.pexp_loc "[%require] expected a constant string"))
          end
      | [%expr [%require_or_default [%e? str] [%e? fallback]]] ->
          begin
              match str, fallback with
              | { pexp_desc = Pexp_constant (Const_string (s, None)) }, { pexp_desc = Pexp_constant (Const_string (fb, None)) } ->
                  let loc = expr.pexp_loc in
                  let args = make_args (make_require_string s) in
                  let otherwise = make_args fb in
                  Exp.try_ ~loc (make_apply loc args) [Exp.case (Pat.any ~loc ()) (make_apply loc otherwise)]
              | _ ->
                raise (Location.Error (
                    Location.error ~loc:expr.pexp_loc "[%require_or_default] expected constant strings"))
          end
      | x -> default_mapper.expr mapper x;
  }

let () = register "require" require_mapper
