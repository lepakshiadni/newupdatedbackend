const bcrpt = require('bcrypt')
const otpSchema = require('../models/otpmodel')
const userSchema = require('../models/usermodel')
const notificationSchema = require('../models/notificationmodel')
// const plivo = require('plivo');
const Axios = require('axios')

// Initialize the fast2Sms client
const authToken = process.env.OTP_TOKEN;

const sendOTP = async (phoneNumber, otp) => {
    const smsData = {
        "route": "otp",
        "variables_values": otp,
        "numbers": phoneNumber,
    }
    await Axios.post('https://www.fast2sms.com/dev/bulkV2', smsData, {
        headers: {
            "authorization": authToken
        }
    })
        .then((resp) => {
            console.log("sms sent successfully", resp.data);
            console.log(resp.data)
        })
        .catch((error) => {
            console.log("error in sending sms", error)
        })
}

const generateOtp = () => {
    //generate otp code 4 digit 
    const otp = Math.floor(1000 + Math.random() * 9000)
    return otp
}

const compareOtp = async (otp, number) => {
    console.log(otp, number)
    const finduser = await otpSchema.findOne(
        {
            phoneNumber: number
        }
    )
    if (!finduser) {
        console.log('user Not fount')
    }
    else {
        const validotp = bcrpt.compare(otp, finduser?.Otp)
        return validotp
    }
}

const decodedpassword = async (email, password) => {
    const find = await userSchema.findOne({ email })
    if (find) {
        let decrypted = await bcrpt.compare(password, find.password)
        return decrypted
    }
    else {
        return false
    }

}

const notifications = async (userId, notifications) => {
    console.log('nofitificaiton', notifications)
    try {
        const findUser = await notificationSchema.findOne({ userId })
        if (findUser) {
            const update = await notificationSchema.findOneAndUpdate(
                { userId },
                { $push: { notifications } },

            )
            return update
        }
        else {
            const create = new notificationSchema(
                {
                    userId,
                    notifications
                }
            )
            create.save()
            return create
        }
    }
    catch (error) {
        console.log(error)
        return error
    }

}


module.exports = { generateOtp, compareOtp, sendOTP, decodedpassword, notifications }

