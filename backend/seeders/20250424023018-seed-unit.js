'use strict';
module.exports = {
  async up(queryInterface) {
    await queryInterface.bulkInsert('Units', [
      { UnitName: 'Kg', createdAt: new Date(), updatedAt: new Date() },
      { UnitName: 'Piece', createdAt: new Date(), updatedAt: new Date() },
      { UnitName: 'Meter', createdAt: new Date(), updatedAt: new Date() },
    ]);
  },
  async down(queryInterface) {
    await queryInterface.bulkDelete('Units', null, {});
  }
};