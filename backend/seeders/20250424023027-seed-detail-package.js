'use strict';
module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('DetailPackages', [
      { PackageID: 1, ServiceID: 1, Quantity: 2, createdAt: new Date(), updatedAt: new Date() },
      { PackageID: 1, ServiceID: 2, Quantity: 1, createdAt: new Date(), updatedAt: new Date() },
      { PackageID: 2, ServiceID: 1, Quantity: 2, createdAt: new Date(), updatedAt: new Date() },
      { PackageID: 2, ServiceID: 3, Quantity: 1, createdAt: new Date(), updatedAt: new Date() },
    ]);
  },
  async down(queryInterface) {
    await queryInterface.bulkDelete('DetailPackages', null, {});
  }
};