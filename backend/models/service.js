'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Service extends Model {
    static associate(models) {
      Service.belongsTo(models.Category, { foreignKey: 'CategoryID' });
      Service.belongsTo(models.Unit, { foreignKey: 'UnitID' });
    }
  }
  Service.init({
    ServiceName: DataTypes.STRING,
    Price: DataTypes.INTEGER,
    CategoryID: DataTypes.INTEGER,
    UnitID: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Service',
  });
  return Service;
};