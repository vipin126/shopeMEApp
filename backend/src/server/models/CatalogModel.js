import { Schema,model } from "mongoose";

const catalogSchema = new Schema({
    userId:{
        type:String,
        required:true,
    },
    productName:{
        type:String,
    },
    category:{
        type:String,
    },
    description:{
        type:String,
    },
    price:{
        type:String,
    },
    images:{
        type:[String],
    }
},{timestamps:true});

export default model('Catalog',catalogSchema);