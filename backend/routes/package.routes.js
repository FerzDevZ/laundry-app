const router = require('express').Router();
const pkg = require('../controllers/package.controller');

router.get('/', pkg.getAll);
router.post('/', pkg.create);

module.exports = router;
