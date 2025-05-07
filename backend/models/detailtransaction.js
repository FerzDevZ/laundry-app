'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class DetailTransaction extends Model {
    static associate(models) {
      DetailTransaction.belongsTo(models.HeaderTransaction, { foreignKey: 'HeaderTransactionID' });
      DetailTransaction.belongsTo(models.Service, { foreignKey: 'ServiceID' });
      DetailTransaction.belongsTo(models.Package, { foreignKey: 'PackageID' });
    }
  }
  DetailTransaction.init({
    HeaderTransactionID: DataTypes.INTEGER,
    ServiceID: DataTypes.INTEGER,
    PackageID: DataTypes.INTEGER,
    Quantity: DataTypes.INTEGER,
    Subtotal: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'DetailTransaction',
  });
  return DetailTransaction;
};