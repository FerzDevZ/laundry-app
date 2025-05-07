'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Package extends Model {
    static associate(models) {
      Package.hasMany(models.DetailPackage, { foreignKey: 'PackageID' });
    }
  }
  Package.init({
    PackageName: DataTypes.STRING,
    Price: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Package',
  });
  return Package;
};