import {api, LightningElement, track, wire} from 'lwc';
import {getPicklistValuesByRecordType} from 'lightning/uiObjectInfoApi';

const RECORD_TYPE_ID = 'recordTypeId';
const SOBJECT_TYPE = 'objectName';
const CONTROLLING_FIELD = 'controllingField';
const WORKFLOW_PATH_NODES = 'nodes';
const CONTROLLING_FIELD_VALUE = 'controllingFieldValue';
const CONTEXTS = 'contexts';

export default class WorkflowConfigurationPath extends LightningElement {

    __workflowPath;
    recordTypeId;
    sObjectField;
    sObjectName;
    isPicklistChanged;
    selectedPathItem;
    picklistFields;
    @track pathItems;

    @wire(getPicklistValuesByRecordType, {recordTypeId: '$recordTypeId', objectApiName: '$sObjectName'})
    setPicklistFields({data, error}) {
        if (data) {
            this.picklistFields = data.picklistFieldValues;
            this.updatePathItems();
            this.resetSelectedPathItem();
        } else if (error) {
            console.error(error);
        }
    }

    get workflowPath() {
        return this.__workflowPath;
    }

    @api set workflowPath(value) {
        this.__workflowPath = value;
        this.initValues();
        this.updatePathItems();
    }

    handleSelection(event) {
        this.selectedPathItem = event.detail.value;
    }

    initValues() {
        let newRecordType = this.__workflowPath && this.__workflowPath[RECORD_TYPE_ID];
        let newSObjectField = this.__workflowPath && this.__workflowPath[CONTROLLING_FIELD];
        let newSObjectType = this.__workflowPath && this.__workflowPath[SOBJECT_TYPE];

        this.isPicklistChanged = newRecordType === this.recordTypeId && newSObjectType === this.sObjectName && newSObjectField !== this.sObjectField;

        this.recordTypeId = newRecordType;
        this.sObjectField = newSObjectField;
        this.sObjectName = newSObjectType;
    }

    updatePathItems() {
        this.pathItems = this.picklistFields && this.picklistFields[this.sObjectField] && this.picklistFields[this.sObjectField].values
            .map((item) => {
                return {
                    label: item.label,
                    value: item.value,
                    stage: this.hasWorkflowPathNodeContexts(item.value) && 'complete'
                };
            });

        this.isPicklistChanged && this.resetSelectedPathItem();
        this.refreshPath();
    }

    resetSelectedPathItem() {
        this.selectedPathItem = this.pathItems && this.pathItems.length > 0 && this.pathItems[0].value;

        this.dispatchEvent(
            new CustomEvent(
                'select',
                {
                    detail: {
                        value: this.selectedPathItem
                    },
                    bubbles: true,
                    composed: true
                },
            )
        );
    }

    refreshPath() {
        setTimeout(() => {
            let path = this.template.querySelector('c-custom-path');
            path && path.setActualStage(this.selectedPathItem);
        });
    }

    hasWorkflowPathNodeContexts(controllingFieldValue) {
        let workflowPathNode = this.__workflowPath[WORKFLOW_PATH_NODES] && this.__workflowPath[WORKFLOW_PATH_NODES].find((workflowPathNode) => {
            return workflowPathNode[CONTROLLING_FIELD_VALUE] === controllingFieldValue;
        });

        return workflowPathNode && workflowPathNode[CONTEXTS] && workflowPathNode[CONTEXTS].length > 0;
    }
}