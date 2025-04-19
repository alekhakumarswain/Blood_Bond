const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.get('/', (req, res) => {
    res.json({ message: 'Welcome to Blood Bond API' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(Server running on port );
});
