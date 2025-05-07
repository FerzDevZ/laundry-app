'use strict';
module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('Employees', [
      {
        FullName: 'Admin Esemka',
        Email: 'admin@esemka.com',
        PhoneNumber: '081234567890',
        Password: 'admin123!',
        JobID: 1,
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ]);
  },
  async down(queryInterface) {
    await queryInterface.bulkDelete('Employees', null, {});
  }
};