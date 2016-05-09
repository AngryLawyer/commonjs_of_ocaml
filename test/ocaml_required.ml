let value =
    let a = [%require "./js_required"] in
    let b = [%require_or_default "./js_required" 6] in
    let c = [%require_or_default "./nonexistant" 7] in
    a + b + c

let () =
    CommonJS.export value
