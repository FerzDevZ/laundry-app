// ✅ app.js versi lengkap sesuai modul LKS + fix routing login

const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
dotenv.config();

const db = require('./models');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Cek koneksi DB
(async () => {
  try {
    await db.sequelize.authenticate();
    console.log('✅ Database connected');
  } catch (err) {
    console.error('❌ Unable to connect to the database:', err);
  }
})();

// Sync DB
(async () => {
  await db.sequelize.sync({ alter: false });
  console.log('📦 Models synchronized');
})();

// Import Controllers
const authController = require('./controllers/auth.controller');

// Import Routes
const authRoutes = require('./routes/auth.routes');
const customerRoutes = require('./routes/customer.routes');
const serviceRoutes = require('./routes/service.routes');
const packageRoutes = require('./routes/package.routes');
const transactionRoutes = require('./routes/transaction.routes');
const pickupRoutes = require('./routes/pickup.routes');

// Register Routes
app.use('/api/auth', authRoutes);
app.use('/api/customers', customerRoutes);
app.use('/api/services', serviceRoutes);
app.use('/api/packages', packageRoutes);
app.use('/api/transactions', transactionRoutes);
app.use('/api/pickups', pickupRoutes);

// Endpoint langsung login (jika mau cepat, bisa juga pakai ini selain routing auth)
app.post('/login', authController.login);

// Default route
app.get('/', (req, res) => {
  res.send('Esemka Laundry API berjalan 🧺');
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Something went wrong!' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server ready at http://localhost:${PORT}`);
});