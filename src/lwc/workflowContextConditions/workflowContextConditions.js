import {LightningElement, api, track} from 'lwc';
import {NamespaceUtils} from 'c/namespaceUtils'
import deleteRecord from '@salesforce/apex/WorkflowPathController.deleteRecord';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

const contextOperatorData = [
    {label: 'IN', value: 'IN'},
    {label: 'EQUALS', value: 'EQUALS'}
];

const CONTEXT_CONDITION_OBJECT_API_NAME = 'ContextCondition__mdt';

export default class WorkflowContextConditions extends LightningElement {
    @api
    get contextConditions() {
        return this.contextConditionsLocal;
    }
    set contextConditions(value) {
        this.contextConditionsLocal = JSON.parse(JSON.stringify(value));
    }
    @api
    get fields() {}
    set fields(value) {
        this.fieldsPicklist = [];
        value.forEach(
            field => this.fieldsPicklist.push({label: field.apiName, value: field.apiName})
        );
    }
    @api contextName;
    @track contextConditions;
    @track contextConditionsLocal;
    @track contextOperatorData = contextOperatorData;
    @track fieldsPicklist;
    @track showSpinner = false;
    namespaceUtils = new NamespaceUtils();

    deleteCondition(event) {
        const name = event.currentTarget.dataset.name;
        this.contextConditionsLocal = this.contextConditionsLocal.filter(
            condition => condition.name !== name
        );
        if (this.getValidationResult(name)) {
            this.dispatchConditionsChangedEvent();
        }
        /*Deleting context condition metadata*/
        this.showSpinner = true;
        if (this.contextConditions.id) {
            deleteRecord({
                objectApiName: this.namespaceUtils.getNamespacePrefix()+CONTEXT_CONDITION_OBJECT_API_NAME,
                developerName: contextConditions.name
            })
                .then(() => {
                    this.handleSuccessToast('The record has been deleted');
                })
                .catch(error => this.handleError(error))
                .finally(() => this.showSpinner = false);
        } else {
            this.contextConditionsLocal.contexts = [...this.contextConditionsLocal.contexts.reduce(
                context => context.name !== this.contextConditions.name
            )];
            this.contextConditions = null;
        }
    }

    handleSuccessToast(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: message,
                variant: 'success'
            })
        );
    }

    addCondition() {
        const name = this.generateConditionName();
        this.contextConditions.push(
            {
                name: name,
                label: name,
                field: null,
                operator: null,
                value: null,
                contextDeveloperName: this.contextName
            });
    }

    generateConditionName() {
        return 'Condition_' + Date.now().toString();
    }

    getValidationResult(excludedName) {
        return [...this.template.querySelectorAll('.condition-required-field')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && (inputCmp.dataset.name === excludedName || inputCmp.checkValidity());
            }, true);
    }

    dispatchConditionsChangedEvent() {
        this.dispatchEvent(new CustomEvent(
            'contextconditionschanged',
            {detail: {
                contextName: this.contextName,
                contextConditions: [...this.contextConditionsLocal]}
            }
        ));
    }

    handleValueChange(event) {
        const conditionName = event.currentTarget.dataset.name;
        const fieldName = event.currentTarget.name;
        let currentCondition = this.findConditionByName(conditionName);
        if (currentCondition) {
            currentCondition[fieldName] = event.currentTarget.value;
        }
        if (this.getValidationResult()) {
            this.dispatchConditionsChangedEvent();
        }
    }

    findConditionByName(name) {
        return this.contextConditionsLocal.find(
            condition => condition.name === name
        );
    }
}