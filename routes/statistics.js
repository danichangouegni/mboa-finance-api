const express = require("express");
const db = require("../db");
const authMiddleware = require("../middleware/auth");

const router = express.Router();

router.get(
 "/",
 authMiddleware,
 async (req,res)=>{

  try{

    const [rows] =
    await db.query(

      `
      SELECT
      category,
      SUM(amount)
      AS total
      FROM transactions
      WHERE user_id = ?
      GROUP BY category
      `,

      [req.user.userId]
    );

    res.json({

      success:true,

      categories:rows

    });

  }
  catch(error){

    res.status(500).json({

      success:false,
      error:error.message

    });

  }

 });

module.exports = router;