const { Service, Category, Unit } = require('../models');

exports.getAll = async (req, res) => {
  const services = await Service.findAll({ include: [Category, Unit] });
  res.json(services);
};

exports.create = async (req, res) => {
  const { ServiceName, Price, EstimationTime, CategoryID, UnitID } = req.body;
  const newService = await Service.create({ ServiceName, Price, EstimationTime, CategoryID, UnitID });
  res.status(201).json(newService);
};

// Update, delete, getById mirip seperti customer
