'use strict';
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Notifications', {
      id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
      CustomerID: {
        type: Sequelize.INTEGER,
        references: { model: 'Customers', key: 'id' }
      },
      Message: Sequelize.TEXT,
      IsRead: { type: Sequelize.BOOLEAN, defaultValue: false },
      createdAt: Sequelize.DATE,
      updatedAt: Sequelize.DATE
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('Notifications');
  }
};
