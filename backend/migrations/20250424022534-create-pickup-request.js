'use strict';
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('PickupRequests', {
      id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
      CustomerID: {
        type: Sequelize.INTEGER,
        references: { model: 'Customers', key: 'id' }
      },
      Status: {
        type: Sequelize.ENUM('Pending', 'Diambil', 'Selesai'),
        defaultValue: 'Pending'
      },
      PickupAddress: {
        type: Sequelize.STRING,
        allowNull: false
      },
      createdAt: Sequelize.DATE,
      updatedAt: Sequelize.DATE
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('PickupRequests');
  }
};