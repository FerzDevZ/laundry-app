const { PickupRequest, Customer } = require('../models');

// GET /api/pickups
exports.getAll = async (req, res) => {
  try {
    const data = await PickupRequest.findAll({
      include: [{ model: Customer }],
      order: [['id', 'DESC']]
    });
    res.json(data);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

// POST /api/pickups
exports.createRequest = async (req, res) => {
  try {
    const { CustomerID, PickupAddress } = req.body;
    // Debug: log input
    console.log('[PickupRequest] POST /api/pickups', { CustomerID, PickupAddress });

    if (!CustomerID || !PickupAddress) {
      console.warn('[PickupRequest] Gagal: CustomerID/PickupAddress kosong', { CustomerID, PickupAddress });
      return res.status(400).json({ 
        message: 'CustomerID dan PickupAddress wajib diisi',
        debug: { CustomerID, PickupAddress }
      });
    }

    // Cek apakah customer ada
    const customer = await Customer.findByPk(CustomerID);
    if (!customer) {
      console.warn('[PickupRequest] Gagal: Customer tidak ditemukan', { CustomerID });
      return res.status(404).json({ 
        message: 'Customer tidak ditemukan',
        debug: { CustomerID }
      });
    }

    const pickup = await PickupRequest.create({
      CustomerID,
      PickupAddress,
      Status: 'Pending'
    });

    console.log('[PickupRequest] Sukses tambah:', pickup.toJSON());
    res.status(201).json({ message: 'Pickup request created', pickup });
  } catch (err) {
    console.error('[PickupRequest] ERROR:', err);
    res.status(500).json({ 
      message: 'Server error', 
      error: err.message,
      stack: err.stack // Tambahkan stack trace untuk debug
    });
  }
};

// PUT /api/pickups/:id/status
exports.updateStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    // Validasi status (opsional, jika ingin membatasi value)
    const allowed = ['Pending', 'Diambil', 'Selesai'];
    if (!allowed.includes(status)) {
      return res.status(400).json({ message: 'Status tidak valid', allowed });
    }

    const pickup = await PickupRequest.findByPk(id);
    if (!pickup) {
      return res.status(404).json({ message: 'Pickup request tidak ditemukan' });
    }

    pickup.Status = status;
    await pickup.save();

    res.json({ message: 'Status pickup berhasil diupdate', pickup });
  } catch (err) {
    console.error('[PickupRequest] ERROR updateStatus:', err);
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
