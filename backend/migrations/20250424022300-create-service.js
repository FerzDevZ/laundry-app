'use strict';
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Services', {
      id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
      ServiceName: Sequelize.STRING,
      Price: Sequelize.DECIMAL(10, 2),
      EstimationTime: Sequelize.INTEGER,
      CategoryID: {
        type: Sequelize.INTEGER,
        references: { model: 'Categories', key: 'id' }
      },
      UnitID: {
        type: Sequelize.INTEGER,
        references: { model: 'Units', key: 'id' }
      },
      createdAt: Sequelize.DATE,
      updatedAt: Sequelize.DATE
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('Services');
  }
};