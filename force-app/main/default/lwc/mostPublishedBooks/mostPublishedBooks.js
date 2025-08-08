import { LightningElement, track } from 'lwc';
import enqueueBookService from '@salesforce/apex/GetBookDataService.enqueueGetBookData';
import { subscribe, onError } from 'lightning/empApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class mostPublishedBooks extends LightningElement {
    channelName = '/event/MostPublishedBooks__e';
    subscription = {};
    @track data = [];

    columns = [
        {
            label: 'Publisher',
            fieldName: 'publisher',
            type: 'text'
        },
        {
            label: 'Author',
            fieldName: 'author',
            type: 'text'
        },
        {
            label: 'Title',
            fieldName: 'title',
            type: 'text'
        },
        {
            label: 'Edition',
            fieldName: 'edition',
            type: 'number'
        }
    ];

    connectedCallback() {
        this.registerErrorListener();
        this.handleSubscribe();

        enqueueBookService()
            .then(() => {
                console.log('Queueable started successfully');
            })
            .catch(error => {
                console.error('Error starting queueable: ', error);
            });
    }

    handleSubscribe() {
        subscribe(this.channelName, -1, (message) => {
            this.handleMessage(message);
        }).then(response => {
            this.subscription = response;
            console.log('Subscribed to: ', this.channelName);
        });
    }

    handleMessage(message) {
        const payload = message.data.payload;

        if (payload.Error__c) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: payload.Error__c,
                    variant: 'error'
                })
            );
            return;
        }

        let detailsArray = [];
        try {
            detailsArray = JSON.parse(payload.Books__c); // should be an array
        } catch (error) {
            console.error('Error parsing data from payload: ', error);
            return;
        }

        const rows = detailsArray.map((item, index) => {
            return {
                id: `${payload.CreatedDate}-${index}`,
                publisher: item.Publisher,
                author: item.Author,
                title: item.Title,
                edition: item.Edition
            };
        });

        this.data = [...rows];
    }

    registerErrorListener() {
        onError((error) => {
            console.log('empApi has thrown an error: ', JSON.stringify(error));
        });
    }
}