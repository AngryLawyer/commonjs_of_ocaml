let export item =
    (Js.Unsafe.js_expr "module")##.exports := item
