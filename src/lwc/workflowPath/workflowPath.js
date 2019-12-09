import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getWorkflowPathAssociation from '@salesforce/apex/WorkflowPathController.getPathAssociation';
import updateRecord from '@salesforce/apex/WorkflowPathController.updateRecord';
import publishPlatformEvent from '@salesforce/apex/WorkflowPathController.publishPlatformEvent';
import workflowPathDataFetchingError from '@salesforce/label/c.Workflows_ErrorWorkflowPathDataFetching';
import recordUpdated from '@salesforce/label/c.Global_RecordUpdated';
import recordUpdateError from '@salesforce/label/c.Global_RecordUpdateError';
import successMessage from '@salesforce/label/c.Global_Success';
import errorMessage from '@salesforce/label/c.Global_Error';


const actionTypes = {
    RECORD_UPDATE: 'Record Update',
    PLATFORM_EVENT: 'Platform Event'
};
export default class WorkflowPath extends LightningElement {

    @track
    workflowPath;
    @api
    recordId ;
    @track
    nodeList;
    @track
    selectedNode;
    @track
    isShowSpinner = false;

    label = {
        workflowPathDataFetchingError,
        recordUpdated,
        recordUpdateError,
        successMessage,
        errorMessage
    };

    connectedCallback() {
        this.getWorkflowPathData();
    }

    getWorkflowPathData() {
        this.isShowSpinner = true;
        const self = this;
        getWorkflowPathAssociation(
            {
                recordId: this.recordId,
            },
        ).then(
            (pathAssociation) => {
                if(pathAssociation){
                    self.workflowPath = pathAssociation.path;
                    self.selectedNode = pathAssociation.activePathNode;
                    if(self.selectedNode && self.selectedNode.actions){
                        self.selectedNode.actions.sort(function(a, b) {
                            return a.order - b.order;
                        });
                    }
                    this.setNodeAttributesAccordingToOrder(self, pathAssociation.path.nodes);
                }
            },
        ).catch(
            (error) => {
                this.showToast('error', this.label.workflowPathDataFetchingError, error.message);
            },
        ).finally(function() {
            self.isShowSpinner = false;
        });
    }

    setNodeAttributesAccordingToOrder(self, nodes) {
        let isSelectedNodeFound = false;
        self.nodeList = nodes.map(function(node) {
            if (isSelectedNodeFound) {
                node.class = 'slds-path__item slds-is-incomplete';
            }
            if (node.id == self.selectedNode.id) {
                isSelectedNodeFound = true;
                node.class = 'slds-path__item slds-is-current slds-is-active';
                node.isSelected = true;
            }
            if (!isSelectedNodeFound) {
                node.class = 'slds-path__item slds-is-complete';
            }
            return node;
        });
    }

    executeAction(event) {
        this.isShowSpinner = true;
        const action = event.detail;
        if (action.type == actionTypes.RECORD_UPDATE) {
            this.processRecordUpdate(action);
        } else if (action.type == actionTypes.PLATFORM_EVENT) {
            this.publishPlatformEvent(action);
        }
    }

    publishPlatformEvent(action) {
        publishPlatformEvent({
            recordId: this.recordId,
            eventName: action.eventName,
            fieldValues: action.parameters.platformEventConfiguration.fieldValueMap
        }).then(result => {
            if (!result.isSuccess) {
                result.errors.forEach(error => {
                    this.showToast('error', this.label.errorMessage, error.message);
                });
            }
        }).catch(error => {
            this.showToast('error', this.label.errorMessage, error.body.message);
        }).finally(() => {
            this.isShowSpinner = false;
        });
    }

    processRecordUpdate(action) {
        const self = this;
        updateRecord({
            recordId: this.recordId,
            fieldName: action.field,
            newValue: action.newValue,
        }).then(() => {
            this.showToast('success', this.label.successMessage, this.label.recordUpdated);
            this.getWorkflowPathData();
        }).catch(
            (error) => {
                this.showToast('error', this.label.recordUpdateError, error.message);
                self.isShowSpinner = false;

            },
        );
    }

    showToast(variant, title, message) {
        if (arguments) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: arguments[1],
                    message: arguments[2],
                    variant: variant,
                }),
            );
        }
    }

    get workflowPathClass() {
        return 'slds-grid slds-path__track ' + (!this.nodeList ? '' : 'whiteFrame');

    }

    get anyNodeSelected() {
        return this.selectedNode;
    }

}