'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class DetailPackage extends Model {
    static associate(models) {
      DetailPackage.belongsTo(models.Package, { foreignKey: 'PackageID' });
      DetailPackage.belongsTo(models.Service, { foreignKey: 'ServiceID' });
    }
  }
  DetailPackage.init({
    PackageID: DataTypes.INTEGER,
    ServiceID: DataTypes.INTEGER,
    Quantity: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'DetailPackage',
  });
  return DetailPackage;
};