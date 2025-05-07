'use strict';
module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('Categories', [
      { CategoryName: 'Cuci Kering', createdAt: new Date(), updatedAt: new Date() },
      { CategoryName: 'Setrika', createdAt: new Date(), updatedAt: new Date() },
      { CategoryName: 'Dry Clean', createdAt: new Date(), updatedAt: new Date() },
    ]);
  },
  async down(queryInterface) {
    await queryInterface.bulkDelete('Categories', null, {});
  }
};
