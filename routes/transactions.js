const express = require("express");
const db = require("../db");
const authMiddleware = require("../middleware/auth");

const router = express.Router();

router.get("/", authMiddleware, async (req, res) => {

  try {

  const [rows] = await db.query(

  `SELECT
      id,
      title,
      amount,
      transaction_type,
      DATE_FORMAT(
        transaction_date,
        '%Y-%m-%d'
      ) AS transaction_date,
      notes
    FROM transactions
    WHERE user_id = ?`,

  [req.user.userId]

);

    res.json({

      success: true,

      transactions: rows

    });

  } catch (error) {

    res.status(500).json({

      success: false,

      error: error.message

    });

  }

});

router.post("/", authMiddleware, async (req, res) => {

  try {

    const {

      title,
      amount,
      transaction_type,
      transaction_date,
      notes

    } = req.body;

    const [result] = await db.query(

      `INSERT INTO transactions
      (
        user_id,
        title,
        amount,
        transaction_type,
        transaction_date,
        notes
      )
      VALUES (?, ?, ?, ?, ?, ?)`,

      [

        req.user.userId,
        title,
        amount,
        transaction_type,
        transaction_date,
        notes

      ]

    );

    res.json({

      success: true,

      transactionId: result.insertId

    });

  } catch (error) {

    res.status(500).json({

      success: false,

      error: error.message

    });

  }

});

router.delete(
  "/:id",
  authMiddleware,
  async (req, res) => {

    try {

      const transactionId =
          req.params.id;

      await db.query(

        `DELETE FROM transactions
         WHERE id = ?
         AND user_id = ?`,

        [
          transactionId,
          req.user.userId
        ]

      );

      res.json({

        success: true

      });

    } catch (error) {

      res.status(500).json({

        success: false,

        error: error.message

      });

    }

  }
);


router.put(
  "/:id",
  authMiddleware,
  async (req, res) => {

    try {

      const transactionId =
          req.params.id;

      const {

        title,
        amount,
        transaction_type,
        transaction_date,
        notes

      } = req.body;

      await db.query(

        `UPDATE transactions
         SET

           title = ?,
           amount = ?,
           transaction_type = ?,
           transaction_date = ?,
           notes = ?

         WHERE id = ?
         AND user_id = ?`,

        [

          title,
          amount,
          transaction_type,
          transaction_date,
          notes,

          transactionId,
          req.user.userId

        ]

      );

      res.json({

        success: true

      });

    } catch (error) {

      res.status(500).json({

        success: false,

        error: error.message

      });

    }

  }
);
module.exports = router;