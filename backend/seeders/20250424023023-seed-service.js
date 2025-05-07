'use strict';
module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('Services', [
      { ServiceName: 'Cuci Kering', Price: 7000, EstimationTime: 48, CategoryID: 1, UnitID: 1, createdAt: new Date(), updatedAt: new Date() },
      { ServiceName: 'Setrika Saja', Price: 5000, EstimationTime: 24, CategoryID: 2, UnitID: 1, createdAt: new Date(), updatedAt: new Date() },
      { ServiceName: 'Cuci Sprei', Price: 15000, EstimationTime: 72, CategoryID: 1, UnitID: 2, createdAt: new Date(), updatedAt: new Date() },
    ]);
  },
  async down(queryInterface) {
    await queryInterface.bulkDelete('Services', null, {});
  }
};