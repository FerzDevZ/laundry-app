'use strict';
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Packages', {
      id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
      PackageName: Sequelize.STRING,
      Price: Sequelize.DECIMAL(10, 2),
      EstimationTime: Sequelize.INTEGER,
      createdAt: Sequelize.DATE,
      updatedAt: Sequelize.DATE
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('Packages');
  }
};
