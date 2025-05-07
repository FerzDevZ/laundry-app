'use strict';
module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('Packages', [
      { PackageName: 'Paket Hemat', Price: 20000, EstimationTime: 48, createdAt: new Date(), updatedAt: new Date() },
      { PackageName: 'Paket Ekspres', Price: 35000, EstimationTime: 24, createdAt: new Date(), updatedAt: new Date() },
    ]);
  },
  async down(queryInterface) {
    await queryInterface.bulkDelete('Packages', null, {});
  }
};