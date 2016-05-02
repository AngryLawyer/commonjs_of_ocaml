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
      | { pexp_desc = Pexp_extension ({ txt = "require"; loc }, pstr)} ->
        begin
            match pstr with
            | PStr [{
                pstr_desc = Pstr_eval({
                    pexp_loc = loc; pexp_desc = Pexp_constant (Const_string (s, None))
                }, _)
            }] ->
                let args = make_args (make_require_string s) in
                make_apply expr.pexp_loc args
            | _ ->
                raise (Location.Error (
                    Location.error ~loc:expr.pexp_loc "[%require] expected a constant string"))
        end
      | { pexp_desc = Pexp_extension ({ txt = "require_or_default"; loc }, pstr)} ->
        begin
            match pstr with
            | PStr [{
                pstr_desc = Pstr_eval({
                    pexp_loc = _; pexp_desc = Pexp_constant (Const_string (s, None))
                }, _)
            }; {
                pstr_desc = Pstr_eval({
                    pexp_loc = _; pexp_desc = Pexp_constant (Const_string (fb, None))
                }, _)
            }] ->
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
