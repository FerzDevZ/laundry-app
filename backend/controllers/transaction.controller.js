const { HeaderTransaction, DetailTransaction, Customer, Service, Package } = require('../models');

// Ambil semua transaksi (untuk list di Flutter)
exports.getAll = async (req, res) => {
  try {
    const data = await HeaderTransaction.findAll({
      include: [
        { model: Customer },
        {
          model: DetailTransaction,
          include: [
            { model: Service },
            { model: Package }
          ]
        }
      ],
      order: [['id', 'DESC']]
    });
    res.json(data);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// Ambil transaksi by id (opsional)
exports.getById = async (req, res) => {
  try {
    const trx = await HeaderTransaction.findByPk(req.params.id, {
      include: [
        { model: Customer },
        {
          model: DetailTransaction,
          include: [
            { model: Service },
            { model: Package }
          ]
        }
      ]
    });
    if (!trx) return res.status(404).json({ message: 'Transaksi tidak ditemukan' });
    res.json(trx);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// Tambah transaksi baru
exports.create = async (req, res) => {
  try {
    const { CustomerID, details } = req.body;
    if (!CustomerID) {
      return res.status(400).json({ message: 'CustomerID wajib diisi' });
    }
    if (!Array.isArray(details) || details.length === 0) {
      return res.status(400).json({ message: 'details harus berupa array dan tidak boleh kosong' });
    }

    // Buat header transaksi
    const header = await HeaderTransaction.create({
      CustomerID,
      TransactionDate: new Date(),
      // Tambahkan field lain jika perlu (IsPickup, PickupAddress, dsb)
    });

    // Buat detail transaksi
    for (const d of details) {
      await DetailTransaction.create({
        HeaderTransactionID: header.id,
        ServiceID: d.ServiceID || null,
        PackageID: d.PackageID || null,
        Quantity: d.Quantity,
        Subtotal: d.Subtotal || 0, // Hitung subtotal jika perlu
      });
    }

    res.status(201).json({ message: 'Transaksi berhasil', header });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
