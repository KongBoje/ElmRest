let express = require("express")
let router = require("express").Router();

let incr = 0;

router.get('/', function (req, res, next) {
    res.render('index', { title: 'Express' });
});

router.get("/counter", (req, res) => {
    res.json({ "Count": incr++ })
})

router.put("/counter/:val", (req, res) => {
    let val = req.params.val;
    res.json({ "Count": val })
})

module.exports = router;