'use strict';
module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('PickupRequests', [
      { CustomerID: 1, Status: 'Pending', createdAt: new Date(), updatedAt: new Date() },
    ]);
  },
  async down(queryInterface) {
    await queryInterface.bulkDelete('PickupRequests', null, {});
  }
};