const express = require("express");
const db = require("../db");
const authMiddleware = require("../middleware/auth");

const router = express.Router();

router.get(
  "/",
  authMiddleware,
  async (req,res) => {

    const [rows] =
      await db.query(

        `
        SELECT *
        FROM goals
        WHERE user_id = ?
        ORDER BY id DESC
        `,

        [req.user.userId]

      );

    res.json({
      success:true,
      goals:rows
    });

  }
);

router.post(
  "/",
  authMiddleware,
  async (req,res)=>{

    const {
    title,
    target_amount,
    current_amount,
    target_date
    } = req.body;

    const [result] =
      await db.query(

        `
        INSERT INTO goals
        (
        user_id,
        title,
        target_amount,
        current_amount,
        target_date
        )
        VALUES (?, ?, ?, ?, ?)
        `,

       [
        req.user.userId,
        title,
        target_amount,
        current_amount,
        target_date
        ]

      );

    res.json({
      success:true,
      goalId:result.insertId
    });

  }
);

router.put(
  "/:id",
  authMiddleware,
  async (req, res) => {

    try {

      const {
        title,
        target_amount,
        current_amount,
        target_date,
        status
      } = req.body;

      await db.query(
        `
        UPDATE goals
        SET
          title = ?,
          target_amount = ?,
          current_amount = ?,
          target_date = ?,
          status = ?
        WHERE id = ?
        AND user_id = ?
        `,
        [
          title,
          target_amount,
          current_amount,
          target_date,
          status,
          req.params.id,
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


router.delete(
  "/:id",
  authMiddleware,
  async (req, res) => {

    try {

      await db.query(
        `
        DELETE FROM goals
        WHERE id = ?
        AND user_id = ?
        `,
        [
          req.params.id,
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


router.post(
  "/:id/contribution",
  authMiddleware,
  async (req, res) => {

    try {

      const { amount } = req.body;

      await db.query(
        `
        UPDATE goals
        SET current_amount =
            current_amount + ?
        WHERE id = ?
        AND user_id = ?
        `,
        [
          amount,
          req.params.id,
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