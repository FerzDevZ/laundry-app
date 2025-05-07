'use strict';
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('DetailTransactions', {
      id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
      HeaderTransactionID: {
        type: Sequelize.INTEGER,
        references: { model: 'HeaderTransactions', key: 'id' }
      },
      ServiceID: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: { model: 'Services', key: 'id' }
      },
      PackageID: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: { model: 'Packages', key: 'id' }
      },
      Quantity: Sequelize.INTEGER,
      Subtotal: Sequelize.DECIMAL(10, 2),
      EstimationTime: Sequelize.INTEGER,
      IsCompleted: Sequelize.BOOLEAN,
      createdAt: Sequelize.DATE,
      updatedAt: Sequelize.DATE
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('DetailTransactions');
  }
};