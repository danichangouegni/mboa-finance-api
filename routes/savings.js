const express = require("express");
const db = require("../db");
const authMiddleware =
    require("../middleware/auth");

const router = express.Router();

router.get(
  "/",
  authMiddleware,
  async (req, res) => {

    try {

      const [rows] =
          await db.query(

        `SELECT *
         FROM savings
         WHERE user_id = ?`,

        [req.user.userId]

      );

      if (rows.length === 0) {

        return res.json({

          success: true,

          current_amount: 0,

          target_amount: 0

        });

      }

      res.json({

        success: true,

        current_amount:
            rows[0].current_amount,

        target_amount:
            rows[0].target_amount

      });

    } catch (error) {

      res.status(500).json({

        success: false,

        error: error.message

      });

    }

  }
);

router.post(
  "/",
  authMiddleware,
  async (req, res) => {

    try {

      const {

        current_amount,
        target_amount,

      } = req.body;

      const [rows] =
          await db.query(

        `SELECT id
         FROM savings
         WHERE user_id = ?`,

        [req.user.userId]

      );

      if (rows.length === 0) {

        await db.query(

          `INSERT INTO savings
          (
            user_id,
            current_amount,
            target_amount
          )
          VALUES (?, ?, ?)`,

          [
            req.user.userId,
            current_amount,
            target_amount
          ]

        );

      } else {

        await db.query(

          `UPDATE savings
           SET

             current_amount = ?,
             target_amount = ?

           WHERE user_id = ?`,

          [
            current_amount,
            target_amount,
            req.user.userId
          ]

        );

      }

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