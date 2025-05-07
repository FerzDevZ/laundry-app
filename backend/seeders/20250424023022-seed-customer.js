'use strict';
module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('Customers', [
      {
        Name: 'John Doe',
        PhoneNumber: '0811111111',
        Address: 'Jalan Raya No. 1',
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ]);
  },
  async down(queryInterface) {
    await queryInterface.bulkDelete('Customers', null, {});
  }
};