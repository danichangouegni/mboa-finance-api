const express = require("express");
const db = require("../db");
const authMiddleware = require("../middleware/auth");

const router = express.Router();

router.get(
  "/",
  authMiddleware,
  async (req, res) => {

    try {

      const [rows] =
        await db.query(
          `
          SELECT *
          FROM debts
          WHERE user_id = ?
          `,
          [req.user.userId]
        );

      res.json({
        success: true,
        debts: rows
      });

    } catch(error) {

      res.status(500).json({
        success:false,
        error:error.message
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
        person_name,
        amount,
        debt_type,
        due_date,
        notes
        } = req.body;


      const [result] =
        await db.query(
          `
         INSERT INTO debts
            (
            user_id,
            person_name,
            amount,
            debt_type,
            due_date,
            notes
            )
            VALUES (?, ?, ?, ?, ?, ?)
          `,
          [
        req.user.userId,
        person_name,
        amount,
        debt_type,
        due_date,
        notes
        ]
        
        );

      res.json({
        success:true,
        debtId:result.insertId
      });

    } catch(error) {

      res.status(500).json({
        success:false,
        error:error.message
      });

    }

  }
);

router.delete(
  "/:id",
  authMiddleware,
  async (req,res)=>{

    try{

      await db.query(
        `
        DELETE FROM debts
        WHERE id = ?
        AND user_id = ?
        `,
        [
          req.params.id,
          req.user.userId
        ]
      );

      res.json({
        success:true
      });

    }catch(error){

      res.status(500).json({
        success:false,
        error:error.message
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
        person_name,
        amount,
        debt_type,
        due_date,
        notes
      } = req.body;

      const formattedDueDate =
        due_date.split("T")[0];

      const [result] = await db.query(
        `
        UPDATE debts
        SET
          person_name = ?,
          amount = ?,
          debt_type = ?,
          due_date = ?,
          notes = ?
        WHERE id = ?
        AND user_id = ?
        `,
        [
          person_name,
          amount,
          debt_type,
          formattedDueDate,
          notes,
          req.params.id,
          req.user.userId
        ]
      );

      res.json({
        success: result.affectedRows > 0
      });

    } catch (error) {

      console.error(error);

      res.status(500).json({
        success: false,
        error: error.message
      });

    }

  }
);

module.exports = router;