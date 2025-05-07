const router = require('express').Router();
const customer = require('../controllers/customer.controller');

router.get('/', customer.getAll);
router.get('/:id', customer.getById);
router.post('/', customer.create);
router.put('/:id', customer.update);
router.delete('/:id', customer.delete);

module.exports = router;
