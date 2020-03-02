import {Document, Schema, Model, model} from "mongoose";
import {ISanitaryRanking} from "../interfaces/ISanitaryRanking";



export interface ISanitaryRankingModel extends ISanitaryRanking, Document{

}


const SanitaryRankingSchema = new Schema({
    cityId: String,
    countryId: String,
    score: {type: Number, default:1}
},{
    timestamps: true
});


export const SanitaryRanking : Model<ISanitaryRankingModel> = model<ISanitaryRankingModel>("SanitaryRanking", SanitaryRankingSchema);
