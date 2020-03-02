'use strict';
import * as express from "express";

import PORT from './config';

const app = express();


import data = require("./data.json");
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
                city: place.name
            });
            return;
        }
    });

});


app.get('/map_data', (req, res) => {
    res.json({success: true, data: mapData});
});

app.listen(PORT, () => {
    console.log(`server listening on port ${PORT}`);
});
