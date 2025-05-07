'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class HeaderTransaction extends Model {
    static associate(models) {
      HeaderTransaction.belongsTo(models.Customer, { foreignKey: 'CustomerID' });
      HeaderTransaction.hasMany(models.DetailTransaction, { foreignKey: 'HeaderTransactionID' });
    }
  }
  HeaderTransaction.init({
    CustomerID: DataTypes.INTEGER,
    TransactionDate: DataTypes.DATE,
    IsPickup: DataTypes.BOOLEAN,
    PickupAddress: DataTypes.TEXT
  }, {
    sequelize,
    modelName: 'HeaderTransaction',
  });
  return HeaderTransaction;
};