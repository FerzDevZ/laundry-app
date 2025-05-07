'use strict';
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('DetailPackages', {
      id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
      PackageID: {
        type: Sequelize.INTEGER,
        references: { model: 'Packages', key: 'id' }
      },
      ServiceID: {
        type: Sequelize.INTEGER,
        references: { model: 'Services', key: 'id' }
      },
      Quantity: Sequelize.INTEGER,
      createdAt: Sequelize.DATE,
      updatedAt: Sequelize.DATE
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('DetailPackages');
  }
};