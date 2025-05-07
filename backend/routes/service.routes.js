const router = require('express').Router();
const svc = require('../controllers/service.controller');

router.get('/', svc.getAll);
router.post('/', svc.create);
// router.put('/:id', svc.update); // opsional
// router.delete('/:id', svc.delete); // opsional

module.exports = router;
