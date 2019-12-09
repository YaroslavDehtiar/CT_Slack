import {LightningElement, api, track, wire} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import deleteRecord from '@salesforce/apex/WorkflowPathController.deleteRecord';
import {NamespaceUtils} from 'c/namespaceUtils';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

const DEFAULT_TYPE = 'Workflow Path';
const CONTEXT_OBJECT_API_NAME = 'Context__mdt';

export default class WorkflowContextConfiguration extends LightningElement {
    namespaceUtils = new NamespaceUtils();

    @api
    get contextData() {}
    set contextData(value) {
        if (this.contextsDataLocal && value && this.contextsDataLocal.name !== value.name) {
            this.currentContext = null;
            this.areContextActionsAvailable = false;
        }
        this.contextsDataLocal = JSON.parse(JSON.stringify(value));
        this.contextsDataLocal.contexts = this.contextsDataLocal.contexts || [];
    };
    @api
    get contextTypes() {
        return this.contextTypesLocal;
    }
    set contextTypes(value) {
        this.contextTypesLocal = JSON.parse(JSON.stringify(value));
    }
    @api
    get objectApiName() {}
    set objectApiName(value) {
        this.parentObjectApiName = value;
        this.populateObjectInfo(value);
    }
    @api
    actions;

    parentObjectApiName;

    @track contextsDataLocal;
    contextTypesLocal;

    @track currentContext;
    @track isEditContextMode;
    @track contextBeingEdited;
    @track contextConditions;
    @track fields;
    @track contextTypesPicklist;
    @track objectApiNameToGetObjectInfo;
    @track filteredActions;
    @track areContextActionsAvailable;
    @track showSpinner = false;

    childRelationships = new Map();
    fieldsByApiName = new Map();

    @wire(getObjectInfo, { objectApiName: '$objectApiNameToGetObjectInfo' })
    objectInfo({data, error}) {
        if (data) {
            if (this.childRelationships.size == 0 && this.objectApiNameToGetObjectInfo === this.parentObjectApiName) {
                this.populateRelationships(data['childRelationships']);
            }
            this.populateFields(data['fields']);
        }
    }

    populateObjectInfo(currentObjectApiName) {
        if (!this.fieldsByApiName.has(currentObjectApiName)) {
            this.objectApiNameToGetObjectInfo = currentObjectApiName;
        } else {
            //get from local cache
            this.fields = this.fieldsByApiName.get(currentObjectApiName);
        }
    }

    populateRelationships(childRelationshipsData) {
        let contextTypesPicklist = [];
        childRelationshipsData.forEach(
            relationship => {
                const contextTypeDeveloperName = this.generateContextTypeDeveloperName(relationship.childObjectApiName, relationship.fieldName);
                this.childRelationships.set(contextTypeDeveloperName, relationship);
                contextTypesPicklist.push(
                    {
                        value: contextTypeDeveloperName,
                        label: `${relationship.childObjectApiName} (${relationship.fieldName})`
                    }
                );
            }
        );
        this.contextTypesPicklist = contextTypesPicklist;
    }

    populateFields(fieldsData) {
        let fields = [];
        Object.keys(fieldsData).forEach(
            apiName => {
                fields.push({
                    apiName: apiName,
                    label: fieldsData[apiName]['label']
                });
                if (apiName === 'RecordTypeId') {
                    fields.push({
                        apiName: 'RecordType.DeveloperName',
                        label: 'RecordType.DeveloperName'
                    });
                }
            }
        );
        this.fieldsByApiName.set(this.objectApiNameToGetObjectInfo, fields);
        this.fields = fields;
    }

    createNewContext(event) {
        const parentName = event.detail.parentName;
        this.isEditContextMode = false;
        this.contextBeingEdited = {
            parentContext: parentName,
            name: this.generateContextName(),
            label: null,
            create: false,
            edit: false,
            deletex: false,
            contextTypeDeveloperName: parentName ? null : this.parentObjectApiName.replace(/__/g, '_'),
            workflowPathNodeDeveloperName: this.contextsDataLocal.name,
            type: DEFAULT_TYPE,
            childContexts: [],
            contextActions: [],
            contextConditions: []
        };
        this.openModal();
    }

    editContext() {
        this.isEditContextMode = true;
        this.contextBeingEdited = this.currentContext;
        this.openModal();
    }

    deleteContext() {
        //We intentionally call Apex method regardless of record Id because the record could be already deployed,
        // but the page has not been refreshed
        this.showSpinner = true;
        deleteRecord({
            objectApiName: this.namespaceUtils.getNamespacePrefix()+CONTEXT_OBJECT_API_NAME,
            developerName: this.currentContext.name
        })
            .then(() => {
            this.handleSuccessToast('The record(s) has been deleted');
        })
            .catch(error => this.handleError(error))
            .finally(() => this.showSpinner = false);
        this.contextsDataLocal.contexts = this.contextsDataLocal.contexts.filter(
            context => context.name !== this.currentContext.name
        );
        this.currentContext = null;
        this.dispatchContextsChangedEvent();
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

    handleError(error) {
        if (error.body) {
            message = error.body.message;
        } else {
            message = 'JS: ' + error.message;
        }

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: message,
                variant: 'error'
            })
        );
    }

    createContextType(name, objectx, fieldName) {
        const newContextType = {
            name: name,
            label: name,
            objectx: objectx,
            relationship: fieldName,
            isControlledByWorkflowPath: true
        };
        this.contextTypesLocal.push(newContextType);
        this.dispatchContextTypeChangedEvent(newContextType);
        return newContextType;
    }

    checkIsControlledByWorkflowPathField(contextType) {
        if (!contextType.isControlledByWorkflowPath) {
            contextType.isControlledByWorkflowPath = true;
            this.dispatchContextTypeChangedEvent(contextType);
        }
    }

    findContextTypeByDeveloperName(developerName) {
        return this.contextTypesLocal.find(
            contextType => contextType.name === developerName
        );
    }

    editModalFieldChange(event) {
        const fieldType = event.currentTarget.type;
        this.contextBeingEdited[event.currentTarget.name] = fieldType === 'checkbox' ? event.currentTarget.checked : event.currentTarget.value;
    }

    openModal() {
        this.template.querySelector('c-modal').open();
    }

    closeModal() {
        this.template.querySelector('c-modal').close();
    }

    handleContextSelection(event) {
        const name = event.detail.name;
        this.contextsDataLocal.contexts.forEach(
            contextItem => {if(contextItem.name === name) {
                this.currentContext = contextItem;
            } else if(contextItem.childContexts) {
                contextItem.childContexts.forEach(
                    childContextItem => {if (childContextItem.name === name) {
                        this.currentContext = childContextItem;
                    }}
                );
            }}
        );
        if (this.currentContext) {
            const contextType = this.findContextTypeByDeveloperName(this.currentContext.contextTypeDeveloperName);
            this.populateObjectInfo(contextType.objectx);
            this.contextConditions = this.currentContext.contextConditions;
            this.filteredActions = this.getFilteredActionsByContextType(this.currentContext.contextTypeDeveloperName);
            this.areContextActionsAvailable = !this.currentContext.parentContext;
        }
    }

    handleContextConditionsChanged(event) {
        const contextName = event.detail.contextName;
        const contextConditions = event.detail.contextConditions;
        let context = this.findContextByName(contextName);
        if (context) {
            context.contextConditions = contextConditions;
            this.dispatchContextsChangedEvent();
        }
    }

    handleEditComplete() {
        const allValid = [...this.template.querySelectorAll(`[data-required-field='true']`)]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        if (allValid) {
            const contextTypeDeveloperName = this.contextBeingEdited.contextTypeDeveloperName;
            let contextType = this.findContextTypeByDeveloperName(contextTypeDeveloperName);
            if (!contextType) {
                let relationship = this.childRelationships.get(contextTypeDeveloperName);
                if (relationship) {
                    contextType = this.createContextType(contextTypeDeveloperName, relationship.childObjectApiName, relationship.fieldName);
                } else {
                    contextType = this.createContextType(contextTypeDeveloperName, this.parentObjectApiName);
                }
            } else {
                this.checkIsControlledByWorkflowPathField(contextType);
            }
            let existingItem = this.findContextByName(this.contextBeingEdited.name);
            if (existingItem) {
                existingItem = this.contextBeingEdited;
            } else if(this.contextBeingEdited.parentContext){
                let parentContext = this.findContextByName(this.contextBeingEdited.parentContext);
                parentContext.childContexts = parentContext.childContexts ? parentContext.childContexts : [];
                parentContext.childContexts.push(this.contextBeingEdited);
            } else {
                this.contextsDataLocal.contexts.push(this.contextBeingEdited);
            }
            this.currentContext = this.contextBeingEdited;
            this.areContextActionsAvailable = !this.currentContext.parentContext;
            this.contextsDataLocal = {...this.contextsDataLocal};
            this.closeModal();
            this.dispatchContextsChangedEvent();
        }
    }

    findContextByName(name) {
        let result = this.contextsDataLocal.contexts.find(
            context => context.name === name
        );
        if (!result) {
            this.contextsDataLocal.contexts.forEach(
                context => {
                    if (!result && context.childContexts) {
                        result = context.childContexts.find(
                            childContext => childContext.name === name
                        );
                    }
                }
            );
        }
        return result;
    }

    dispatchContextsChangedEvent() {
        this.dispatchEvent(new CustomEvent('contextschanged', {detail: {...this.contextsDataLocal}}));
    }

    dispatchContextTypeChangedEvent(newContextType) {
        this.dispatchEvent(new CustomEvent('contexttypechanged', {detail: {...newContextType}}));
    }

    generateContextName() {
        return 'Context_' + Date.now().toString();
    }

    generateContextTypeDeveloperName(sobjectName, fieldName) {
        let result;
        if (fieldName) {
            result = `${sobjectName}_${fieldName}`;
        } else {
            result = `${sobjectName}`;
        }
        return result.replace(/__/g, '_');
    }

    handleContextActionsChanged(event) {
        const contextActions = event.detail.contextActions;
        const contextName = event.detail.contextName;
        let context = this.findContextByName(contextName);
        if (context) {
            context.contextActions = contextActions;
            this.dispatchContextsChangedEvent();
        }
    }

    getFilteredActionsByContextType(contextTypeDeveloperName) {
        return this.actions.filter(
            action => action.contextTypeDeveloperName === contextTypeDeveloperName
        ).map(
            action => {
                let actionClone = {...action};
                const parameters = action.parameters ? JSON.parse(action.parameters) : null;
                const platformEventConfiguration = parameters ? parameters.platformEventConfiguration : null;
                actionClone['eventName'] = platformEventConfiguration ? platformEventConfiguration.name : null;
                return actionClone;
            }
        );
    }
}