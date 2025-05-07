'use strict';
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Customers', {
      id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
      Name: Sequelize.STRING,
      PhoneNumber: { type: Sequelize.STRING, unique: true },
      Address: Sequelize.TEXT,
      createdAt: Sequelize.DATE,
      updatedAt: Sequelize.DATE
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('Customers');
  }
};