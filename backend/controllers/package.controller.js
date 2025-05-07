const { Package, DetailPackage, Service } = require('../models');

exports.getAll = async (req, res) => {
  const data = await Package.findAll({
    include: [{ model: DetailPackage, include: [Service] }]
  });
  res.json(data);
};

exports.create = async (req, res) => {
  const { PackageName, Price, EstimationTime, Services } = req.body;
  const pkg = await Package.create({ PackageName, Price, EstimationTime });

  for (const item of Services) {
    await DetailPackage.create({
      PackageID: pkg.id,
      ServiceID: item.ServiceID,
      Quantity: item.Quantity
    });
  }

  res.status(201).json(pkg);
};
