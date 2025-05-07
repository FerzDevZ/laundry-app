'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Customer extends Model {
    static associate(models) {
      // define association here jika perlu
    }
  }
  Customer.init({
    Name: DataTypes.STRING,
    PhoneNumber: DataTypes.STRING,
    Address: DataTypes.TEXT
  }, {
    sequelize,
    modelName: 'Customer',
  });
  return Customer;
};