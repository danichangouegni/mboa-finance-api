const express = require("express");
const bcrypt = require("bcrypt");
const db = require("../db");
const jwt = require("jsonwebtoken");
require("dotenv").config();
const router = express.Router();
const authMiddleware = require("../middleware/auth");
const transporter = require("../utils/mailer");
router.post("/register", async (req, res) => {

  try {

    const {
      full_name,
      email,
      password
    } = req.body;
const cleanEmail = email.trim().toLowerCase();

const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;

if (!passwordRegex.test(password)) {

  return res.status(400).json({

    success: false,
    code: "WEAK_PASSWORD"
  });

}
const emailRegex =
  /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
if (!emailRegex.test(email)) {

    return res.status(400).json({
      success:false,
      code:"INVALID_EMAIL"
    });

}
    if (!full_name || !email || !password) {
      return res.status(400).json({
        success: false,
        code: "REQUIRED_FIELDS"
      });

    }

    const [existingUser] = await db.query(

      "SELECT id FROM users WHERE email = ?",

      [cleanEmail]

    );

    if (existingUser.length > 0) {

      return res.status(400).json({
        success: false,
        code: "EMAIL_ALREADY_EXISTS"
      });

    }

    const passwordHash =
      await bcrypt.hash(password, 10);

const [result] = await db.query(

  `INSERT INTO users
  (
    full_name,
    email,
    password_hash,
    trial_start_date,
    subscription_status
  )
  VALUES (
    ?,
    ?,
    ?,
    NOW(),
    'trial'
  )`,

  [
    full_name,
    cleanEmail,
    passwordHash
  ]

);

    res.json({
      success: true,
      code: "ACCOUNT_CREATED",
      user_id: result.insertId
    });

  } catch (error) {

    console.error(error);

res.status(500).json({

  success: false,

 code: "SERVER_ERROR"

});

  }

});

router.post("/login", async (req, res) => {

  try {

    const { email, password } = req.body;
    const cleanEmail = email.trim().toLowerCase();

    if (!email || !password) {

      return res.status(400).json({
        success: false,
      code: "LOGIN_FIELDS_REQUIRED"
      });

    }

    const [users] = await db.query(

      "SELECT * FROM users WHERE email = ?",

      [cleanEmail]

    );

      if (users.length === 0) {
        return res.status(401).json({
          success: false,
          code: "INVALID_CREDENTIALS"
        });
      }

    const user = users[0];

    const passwordMatch =
      await bcrypt.compare(
        password,
        user.password_hash
      );

      if (!passwordMatch) {
        return res.status(401).json({
          success: false,
          code: "INVALID_CREDENTIALS"
        });
      }

// ----- VERIFICATION ABONNEMENT -----

const today = new Date();

if (
  user.subscription_status === "trial"
) {

  const trialStart =
      new Date(
        user.trial_start_date,
      );

  const trialEnd =
      new Date(
        trialStart,
      );

  trialEnd.setDate(
    trialEnd.getDate() + 30,
  );

  if (today > trialEnd) {

    return res.status(403).json({

      success: false,

      paymentRequired: true,

      code: "TRIAL_EXPIRED",

    });

  }

}

    await db.query(

  "UPDATE users SET last_login = NOW() WHERE id = ?",

  [user.id]

);

    const token = jwt.sign(

      {
        userId: user.id,
        email: user.email
      },

      process.env.JWT_SECRET,

      {
        expiresIn: "7d"
      }

    );

    res.json({

      success: true,

      token,

      user: {

        id: user.id,

        full_name: user.full_name,

        email: user.email,

        language: user.language,

        theme: user.theme

      }

    });

  } catch (error) {

    console.error(error);

res.status(500).json({

  success: false,
code: "SERVER_ERROR"

});

  }

});

router.get(

  "/profile",

  authMiddleware,

  async (req, res) => {

    try {

      const [users] =
        await db.query(

          `SELECT
            id,
            full_name,
            email,
            language,
            theme,
            notifications,
            currency
           FROM users
           WHERE id = ?`,

          [req.user.userId]

        );

      if (users.length === 0) {

        return res.status(404).json({

          success: false,

        code: "INVALID_CREDENTIALS"

        });

      }

      res.json({

        success: true,

        user: users[0]

      });

    } catch (error) {

      console.error(error);

res.status(500).json({

  success: false,
code: "SERVER_ERROR"

});

    }

  }

);

router.post("/logout", (req, res) => {

  res.json({

    success: true,

    message: "Déconnexion réussie"

  });

});

router.get(

  "/me",

  authMiddleware,

  async (req, res) => {

    try {

      const [users] = await db.query(

        `SELECT
          id,
          full_name,
          email,
          language,
          theme
        FROM users
        WHERE id = ?`,

        [req.user.userId]

      );

      res.json({

        success: true,

        user: users[0]

      });

    } catch (error) {

      console.error(error);

res.status(500).json({

  success: false,
code: "SERVER_ERROR"

});

    }

  }

);

router.post(
  "/forgot-password",
  async (req, res) => {

    try {

      const { email } = req.body;

      const [users] =
          await db.execute(

        `
        SELECT *
        FROM users
        WHERE email = ?
        `,
        [email]

      );

  if (users.length === 0) {

  return res.status(404).json({

    success: false,

    code: "EMAIL_NOT_FOUND"

  });

}

      const code =
          Math.floor(
            100000 +
            Math.random() * 900000
          ).toString();

      await db.execute(

        `
        INSERT INTO password_resets
        (email, reset_code, expires_at)
        VALUES (
          ?,
          ?,
          DATE_ADD(NOW(), INTERVAL 15 MINUTE)
        )
        `,

        [email, code]

      );

      console.log(
        "RESET CODE:",
        code
      );
await transporter.sendMail({

  from:
      process.env.EMAIL_USER,

  to: email,

  subject:
    "MBOA - Password Reset / Réinitialisation du mot de passe",

  html: `

    <h2>MBOA Finance</h2>

    <p>
      Votre code de réinitialisation est :
    </p>

    <h1>${code}</h1>

    <p>
      Valable 15 minutes.
    </p>

    <hr>

    <p>
      Your password reset code is:
    </p>

    <h1>${code}</h1>

    <p>
      Valid for 15 minutes.
    </p>

  `,

});

      return res.json({

        success: true,

       code: "RESET_CODE_SENT"

      });

    } catch (error) {

      console.error(error);
      return res.status(500).json({
        success: false,
        code: "SERVER_ERROR"
      });

    }

  }
);

router.post(
  "/verify-reset-code",
  async (req, res) => {

    const {
      email,
      code
    } = req.body;

    const [rows] =
        await db.execute(

      `
      SELECT *
      FROM password_resets
      WHERE email = ?
      AND reset_code = ?
      AND expires_at > NOW()
      ORDER BY id DESC
      LIMIT 1
      `,

      [email, code]

    );

    if (rows.length === 0) {

      return res.json({

        success: false,
       code:"INVALID_RESET_CODE"
      });

    }

    return res.json({

      success: true

    });

  }
);

router.post(
  "/reset-password",
  async (req, res) => {

    try {

      const {
        email,
        code,
        password
      } = req.body;

      const [rows] =
          await db.execute(

        `
        SELECT *
        FROM password_resets
        WHERE email = ?
        AND reset_code = ?
        AND expires_at > NOW()
        ORDER BY id DESC
        LIMIT 1
        `,

        [email, code]

      );

      if (rows.length === 0) {

        return res.json({

          success: false,

        code: "INVALID_RESET_CODE"

        });

      }

      const hash =
          await bcrypt.hash(
            password,
            10
          );

        await db.execute(
          `
        UPDATE users
        SET password_hash = ?
        WHERE email = ?
          `,
          [hash, email]
        );
        await db.execute(
        `
        DELETE FROM password_resets
        WHERE email = ?
        `,
        [email]
        );
      return res.json({

        success: true,

       code: "PASSWORD_UPDATED"

      });

    } catch (error) {

      console.error(error);

return res.status(500).json({
  success: false,
  code: "SERVER_ERROR"
});

    }

  }
);

router.put(
  "/settings/currency",
  authMiddleware,
  async (req, res) => {

    try {

      const { currency } = req.body;

      await db.query(

        `
        UPDATE users
        SET currency = ?
        WHERE id = ?
        `,

        [
          currency,
          req.user.userId
        ]

      );

      res.json({
        success: true
      });

    } catch (error) {

      res.status(500).json({
        success: false
      });

    }

  }
);

router.put("/preferences", authMiddleware,
async (req, res) => {

  const {
    language,
    currency,
  } = req.body;

  await db.query(
    `
    UPDATE users
    SET
      language = ?,
      currency = ?
    WHERE id = ?
    `,
    [
      language,
      currency,
      req.user.userId,
    ]
  );

  res.json({
    success: true,
  });
});
module.exports = router;