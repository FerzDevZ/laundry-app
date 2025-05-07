'use strict';
module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('Notifications', [
      { CustomerID: 1, Message: 'Pickup request received.', IsRead: false, createdAt: new Date(), updatedAt: new Date() },
    ]);
  },
  async down(queryInterface) {
    await queryInterface.bulkDelete('Notifications', null, {});
  }
};