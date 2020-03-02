import {Document, Schema, Model, model} from "mongoose";
import {INewsHeadline} from "../interfaces/INewsHeadline";

export interface INewsHeadlineModel extends INewsHeadline, Document{
}


const NewsHeadlineSchema = new Schema({
    source: {
        id: String,
        name: String,
    },
    author: String,
    title: String,
    description: String,
    url: String,
    urlToImage: String,
    publishedAt: Date,
    content: String
},{
    timestamps: true
});
export const NewsHeadline : Model<INewsHeadlineModel> = model<INewsHeadlineModel>("NewsHeadline", NewsHeadlineSchema);

