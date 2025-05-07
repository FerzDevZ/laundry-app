const { Employee } = require('../models');

exports.login = async (req, res) => {
  const { email, password } = req.body;
  try {
    // Kolom di database: Email (huruf besar E)
    const user = await Employee.findOne({ where: { Email: email } });

    if (!user || user.Password !== password) {
      return res.status(401).json({ message: 'Email atau password salah' });
    }

    res.status(200).json({
      message: 'Login berhasil',
      user: {
        id: user.id,
        name: user.FullName,
        email: user.Email,
        jobId: user.JobID
      }
    });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};
