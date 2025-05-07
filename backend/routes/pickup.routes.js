const router = require('express').Router();
const pickup = require('../controllers/pickup.controller');

router.get('/', pickup.getAll);
router.post('/', pickup.createRequest);
router.put('/:id/status', pickup.updateStatus); // <-- INI untuk update status

module.exports = router;
