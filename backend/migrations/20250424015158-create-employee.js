'use strict';
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Employees', {
      id: { type: Sequelize.INTEGER, autoIncrement: true, primaryKey: true },
      FullName: Sequelize.STRING,
      Email: { type: Sequelize.STRING, unique: true },
      PhoneNumber: Sequelize.STRING,
      Password: Sequelize.STRING,
      JobID: {
        type: Sequelize.INTEGER,
        references: { model: 'Jobs', key: 'id' },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL'
      },
      createdAt: Sequelize.DATE,
      updatedAt: Sequelize.DATE
    });
  },
  async down(queryInterface) {
    await queryInterface.dropTable('Employees');
  }
};