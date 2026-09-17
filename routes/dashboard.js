const express = require("express");
const db = require("../db");
const authMiddleware = require("../middleware/auth");

const router = express.Router();

router.get(
  "/",
  authMiddleware,
  async (req, res) => {

    try {

      const userId =
        req.user.userId;

      const [income] =
        await db.query(
          `
          SELECT
          SUM(amount) total
          FROM transactions
          WHERE user_id = ?
          AND transaction_type='income'
          `,
          [userId]
        );

      const [expense] =
        await db.query(
          `
          SELECT
          SUM(amount) total
          FROM transactions
          WHERE user_id = ?
          AND transaction_type='expense'
          `,
          [userId]
        );

      const revenus =
          income[0].total || 0;

      const depenses =
          expense[0].total || 0;

      const solde =
          revenus - depenses;

      res.json({

        success:true,

        balance:solde,

        income:revenus,

        expense:depenses

      });

    } catch(error){

      res.status(500).json({
        success:false,
        error:error.message
      });

    }

  }
);

module.exports = router;
