require("dotenv").config();

const express = require("express");
const cors = require("cors");

const db = require("./db");

const authRoutes = require("./routes/auth");
const transactionsRoutes = require("./routes/transactions");
const savingsRoutes = require("./routes/savings");
const tontinesRoutes = require("./routes/tontines");
const debtsRoutes = require("./routes/debts");
const dashboardRoutes = require("./routes/dashboard");
const statisticsRoutes = require("./routes/statistics");
const goalsRoutes = require("./routes/goals");
const subscriptionRoutes = require("./routes/subscriptions");
const app = express();
app.set("trust proxy", 1);
const rateLimit = require("express-rate-limit");
app.set('trust proxy', 1);

app.use(cors());
app.use(express.json());
app.use("/api/goals", goalsRoutes);

app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "MoneyPilot API fonctionne",
  });
});

app.get("/test-db", async (req, res) => {
  try {
    const [rows] = await db.query(
      "SELECT NOW()"
    );

    res.json(rows);
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});
const loginLimiter =
rateLimit({

  windowMs:
    15 * 60 * 1000,

  max: 10,

  message: {

    success: false,

    message:
      "Trop de tentatives de connexion. Réessayez plus tard."

  }

});
app.use("/api/auth/login", loginLimiter);
app.use("/api/auth", authRoutes);

app.use(
  "/api/transactions",
  transactionsRoutes
);

app.use(
  "/api/savings",
  savingsRoutes
);

app.use(
  "/api/tontines",
  tontinesRoutes
);

app.use(
  "/api/debts",
  debtsRoutes
);

app.use(
  "/api/dashboard",
  dashboardRoutes
);

app.use(
  "/api/statistics",
  statisticsRoutes
);
app.use(
  "/api/subscriptions",
  subscriptionRoutes
);

const PORT =
  process.env.PORT || 3000;

app.listen(
  PORT,
  "0.0.0.0",
  () => {

    console.log(
      `Serveur lancé sur le port ${PORT}`
    );

  }
);