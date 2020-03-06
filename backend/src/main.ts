'use strict';
import * as dotenv from "dotenv";

dotenv.config();
import * as express from "express";

import {createClient, RedisClient} from "redis";
import * as mongoose from 'mongoose';

const PORT: string | number = process.env.PORT || 5000;
import * as Agenda from "agenda";

const app = express();

// News api
const NewsAPI = require('newsapi');
const newsapi = new NewsAPI(process.env.NEWS_API_KEY);

// Redis
var redisClient: RedisClient;
redisClient = createClient(
    parseInt(process.env.REDIS_PORT),
    process.env.REDIS_HOST,
    {
        password: process.env.REDIS_PASSWORD
    }
);

redisClient.on("error", function (err) {
    console.log(`Redis error ${err}`);
});

redisClient.on("connect", function () {
    console.log("Redis successfully connected");
});

mongoose.connect(process.env.DB_URL);
mongoose.connection.on('connected', function () {
    console.log("Mongoose successfully connected");
    // Agenda
    const agenda = new Agenda();
    agenda.mongo(mongoose.connection.db);
    agenda.on("ready", async () => {
        agenda.define("fetchNews", async job => {
            console.log("running fetch news...");
            redisClient.get("last_news_fetch_date", async (err, lastFetchDateString) => {
                if (err) return console.log(err);
                console.log("lastFetchDateString", lastFetchDateString);
                const lastFetchDate = new Date(Date.parse(lastFetchDateString));
                console.log("lastFetchDate", lastFetchDate);
                var diff = (new Date().getTime() - lastFetchDate.getTime()) / 1000;
                diff /= 60;
                diff = Math.abs(Math.round(diff));
                console.log("diff", diff);
                if (diff > 30) {
                    newsapi.v2.topHeadlines({
                        q: '',
                        language: 'en',
                        country: 'us'
                    }).then(response => {
                        const articles = response["articles"];
                        NewsHeadline.create(articles);
                        redisClient.set("last_news_fetch_date", new Date().toISOString());
                    });
                } else {
                    console.log("not fetching news diff =", diff);
                }
            });
        });

        agenda.every('30 minutes', 'fetchNews');

        agenda.start();
    });

    if (process.env.NODE_ENV != "prod") {
        const Agendash = require('agendash');
        app.use('/dash', Agendash(agenda));
    }

});
mongoose.connection.on('error', function (error) {
    console.log("Mongoose connection error");
    console.log(error);
});
mongoose.connection.on('disconnected', function () {
    console.log("Mongoose connection disconnected");
});


import data = require("./data.json");
import {NewsHeadline} from "./models/NewsHeadline";
import {SanitaryRanking} from "./models/SanitaryRanking";

interface IMapData {
    latitude: number,
    longitude: number,
    createdAt: number,
    infected: number,
    recovered: number,
    dead: number,
    city: string
}

const mapData: Array<IMapData> = [];

data.reports.forEach((report) => {
    data.places.forEach((place) => {
        if (place.id == report.placeId) {
            mapData.push(<IMapData>{
                latitude: place.latitude,
                longitude: place.longitude,
                createdAt: new Date(report.date).getTime(),
                infected: report.infected,
                recovered: report.recovered,
                dead: report.dead,
                city: place.name,
                last_updated: report.date
            });
            return;
        }
    });

});


app.get('/map_data', (req, res) => {
    res.json({success: true, data: mapData});
});

app.get('/news', async (req, res) => {
    const results = await NewsHeadline.find({}).sort({createdAt: -1}).limit(12);
    res.json({success: true, data: results});
});

const fs = require('fs');

app.get('/get_countries', async (req, res) => {
    let rawdata = fs.readFileSync('./src/countries-stripped.json');
    let countriesJson = JSON.parse(rawdata);
    res.json({success: true, countries: countriesJson});
});

app.get('/get_states', async (req, res) => {
    const query = req.query;
    if (!query) {
        res.json({success:false});
        return;
    }

    const countryId = query["countryId"];
    if (!countryId) {
        res.json({success:false});
        return;
    }

    let rawdata = fs.readFileSync('./src/states.json');
    let statesJson = JSON.parse(rawdata);
    const states = statesJson["states"];
    let statesResults = [];
    states.forEach((state)=>{
        if (state["country_id"] === countryId) {
            statesResults.push(state);
        }
    });
    res.json({success: true, states: statesResults});
});

app.get('/get_cities', async(req, res)=>{
    const query = req.query;
    if (!query) {
        res.json({success:false});
        return;
    }

    const stateId = query["stateId"];
    if (!stateId) {
        res.json({success:false});
        return;
    }

    let rawdata = fs.readFileSync('./src/cities-stripped.json');
    let cities = JSON.parse(rawdata);
    const results = [];
    cities.forEach((city)=>{
        if (city["state_id"] === stateId) {
            results.push(city);
        }
    });
    res.json({success:true, cities: results});

});

interface ICityRank {
    cityId: string,
    name: string,
    score: number
}

interface ICountryRank {
    countryId: string,
    name:string,
    score: number
}


app.get('/sanitary_rankings', async (req, res) => {
    const results = await SanitaryRanking.find({});
    let cityRankings: Array<ICityRank> = [];
    let countryRankings: Array<ICountryRank> = [];
    let countryCityTotals = new Map<string, number>();

    // TODO: no need to load file each time. find a way to not load it to improve speed.
    let citiesRawData = fs.readFileSync('./src/cities-stripped.json');
    let cities = JSON.parse(citiesRawData);

    let countriesRawFile = fs.readFileSync('./src/countries-stripped.json');
    let countriesJson = JSON.parse(countriesRawFile);


    results.forEach((result) => {
        const countryId = result["countryId"];
        const score = result["score"];
        let cityName = "";
        cityRankings.push(<ICityRank>{
            cityId: result["cityId"],
            name: cities.find((city)=> city["city_id"] == result["cityId"])["name"],
            score: score
        });
        if (countryCityTotals.has(countryId)) {
            const currentVal = countryCityTotals.get(countryId);
            countryCityTotals.set(countryId, currentVal + score);
        } else {
            countryCityTotals.set(countryId, score);
        }
    });

    countryCityTotals.forEach((score, countryId, map) => {
        countryRankings.push(<ICountryRank>{
            countryId: countryId,
            score: score,
            name:countriesJson.find((country)=> country["id"] == countryId)["name"],
        })
    });

    res.json({
        success: true,
        data: {
            "city_rankings": cityRankings,
            "country_rankings": countryRankings
        }
    })

});

app.get('/sanitary_entry', async (req, res) => {
    const body = req.query;
    if (body == null) {
        res.json({success: false});
        return;
    }
    const cityId = body["cityId"];
    const countryId = body["countryId"];
    if (cityId == null && countryId == null) {
        res.json({success: false});
        return;
    }
    try {
        const result = await SanitaryRanking.findOneAndUpdate({
            cityId: cityId,
            countryId: countryId
        }, {
            $inc: {
                score: 1
            },
            $setOnInsert: {
                cityId: cityId,
                countryId: countryId,
            }
        }, {
            upsert: true,
            new: true
        });
    } catch (e) {
        console.log("Error", e);
    }
    res.json({success: true});
});


process.on('SIGINT', function () {
    redisClient.quit();
    process.exit();
});

process.on('SIGTERM', function () {
    redisClient.quit();
    process.exit();
});


app.listen(PORT, () => {
    console.log(`server listening on port ${PORT}`);
});
