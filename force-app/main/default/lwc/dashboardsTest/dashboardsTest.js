import { LightningElement } from 'lwc';

import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import highcharts from '@salesforce/resourceUrl/DashboardsScriptAndStyle';

export default class DashboardsTest extends LightningElement {
    

    connectedCallback(){
        loadScript(this, highcharts + '/myLib.js').then(() => {
            let result = highcharts.myFunction(2,2);
    
        })
    }


}