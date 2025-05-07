'use strict';
module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('Jobs', [
      { JobName: 'Admin', createdAt: new Date(), updatedAt: new Date() },
      { JobName: 'Manager', createdAt: new Date(), updatedAt: new Date() },
      { JobName: 'Pickup Officer', createdAt: new Date(), updatedAt: new Date() },
      { JobName: 'Cashier', createdAt: new Date(), updatedAt: new Date() },
      { JobName: 'Laundry Operator', createdAt: new Date(), updatedAt: new Date() },
    ]);
  },
  async down(queryInterface) {
    await queryInterface.bulkDelete('Jobs', null, {});
  }
};