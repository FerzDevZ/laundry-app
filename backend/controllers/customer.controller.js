const { Customer } = require('../models');

exports.getAll = async (req, res) => {
  const customers = await Customer.findAll();
  res.json(customers);
};

exports.getById = async (req, res) => {
  const customer = await Customer.findByPk(req.params.id);
  if (!customer) return res.status(404).json({ message: 'Customer not found' });
  res.json(customer);
};

exports.create = async (req, res) => {
  const { Name, PhoneNumber, Address } = req.body;
  const newCustomer = await Customer.create({ Name, PhoneNumber, Address });
  res.status(201).json(newCustomer);
};

exports.update = async (req, res) => {
  const { Name, PhoneNumber, Address } = req.body;
  const customer = await Customer.findByPk(req.params.id);
  if (!customer) return res.status(404).json({ message: 'Customer not found' });

  customer.Name = Name;
  customer.PhoneNumber = PhoneNumber;
  customer.Address = Address;
  await customer.save();

  res.json(customer);
};

exports.delete = async (req, res) => {
  const customer = await Customer.findByPk(req.params.id);
  if (!customer) return res.status(404).json({ message: 'Customer not found' });

  await customer.destroy();
  res.json({ message: 'Customer deleted successfully' });
};
