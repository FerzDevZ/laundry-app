const router = require('express').Router();
const trx = require('../controllers/transaction.controller');

router.get('/', trx.getAll); // TAMBAHKAN INI!
router.post('/', trx.create);
// router.get('/:id', trx.getById);

module.exports = router;
