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
         FROM tontines
         WHERE user_id = ?`,

        [req.user.userId]

      );

      res.json({

        success: true,
        tontines: rows

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
        name,
        contribution,
        members
      } = req.body;

      const [result] =
          await db.query(

        `INSERT INTO tontines
        (
          user_id,
          name,
          contribution,
          members
        )
        VALUES (?, ?, ?, ?)`,

        [
          req.user.userId,
          name,
          contribution,
          members
        ]

      );

      res.json({

        success: true,
        tontineId:
            result.insertId

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

      const {
        name,
        contribution,
        members
      } = req.body;

      await db.query(
        `
        UPDATE tontines
        SET
          name = ?,
          contribution = ?,
          members = ?
        WHERE id = ?
        AND user_id = ?
        `,
        [
          name,
          contribution,
          members,
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