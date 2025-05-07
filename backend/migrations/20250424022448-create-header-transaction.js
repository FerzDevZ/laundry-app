'use strict';
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('HeaderTransactions', {
      id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
      CustomerID: {
        type: Sequelize.INTEGER,
        references: { model: 'Customers', key: 'id' }
      },
      TransactionDate: Sequelize.DATE,
      IsPickup: Sequelize.BOOLEAN,
      PickupAddress: Sequelize.TEXT,
      createdAt: Sequelize.DATE,
      updatedAt: Sequelize.DATE
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('HeaderTransactions');
  }
};