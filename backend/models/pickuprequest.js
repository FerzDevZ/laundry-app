'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class PickupRequest extends Model {
    static associate(models) {
      PickupRequest.belongsTo(models.Customer, { foreignKey: 'CustomerID' });
    }
  }
  PickupRequest.init({
    CustomerID: DataTypes.INTEGER,
    PickupAddress: DataTypes.STRING,
    Status: {
      type: DataTypes.STRING,
      defaultValue: 'Pending'
    }
  }, {
    sequelize,
    modelName: 'PickupRequest',
  });
  return PickupRequest;
};