import {api, LightningElement, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getWorkflow from '@salesforce/apex/WorkflowPathConfigurationController.getWorkflow';
import deployWorkflowPath from '@salesforce/apex/WorkflowPathConfigurationController.deployWorkflowPath';

export default class WorkflowPathConfiguration extends LightningElement {

    @api
    recordType;

    @api
    controllingField;

    @api
    masterLabel;

    @api
    developerName;

    @api
    sObjectName;

    workflowPathConfigurationDto;

    @track
    currentWorkFlowPathNode;

    @track
    contextTypes;

    @track
    objectApiName;

    @track
    actions;

    @track
    showSpinner = false;

    @track
    showContextConfiguration = false;

    connectedCallback() {
        this.enableSpinner();
        const params = {
            recordType: this.recordType,
            controllingField: this.controllingField,
            masterLabel: this.masterLabel,
            developerName: this.developerName,
            sObjectName: this.sObjectName
        };

        getWorkflow({
            params: JSON.stringify(params)
        })
            .then(workflowPathConfigurationDto => {
                this.disableSpinner();
                this.workflowPathConfigurationDto = workflowPathConfigurationDto;
                this.objectApiName = workflowPathConfigurationDto.workflowPath.objectName;
                this.contextTypes = workflowPathConfigurationDto.contextTypes;
                this.actions = workflowPathConfigurationDto.actions;

                const customPath = this.template.querySelector('c-workflow-configuration-path');
                if (customPath) {
                    customPath.workflowPath = this.workflowPathConfigurationDto.workflowPath;
                }
            })
            .catch(error =>{
                this.disableSpinner();
                const message = error.body ? error.body.message : error;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: message,
                    variant: 'error'
                }));
            })
    }

    onNodeSelect(event){
        const node = this.findNodeByValue(event.detail.value);
        this.currentWorkFlowPathNode = node ? node : this.getNewPathNode(event.detail.value);
        if (!this.showContextConfiguration) {
            this.showContextConfiguration = true;
        }
    }

    getNewPathNode(controllingFieldValue){
        return {
            label: controllingFieldValue,
            name: 'PathNode_' + Date.now().toString(),
            workflowPathDeveloperName: this.workflowPathConfigurationDto.workflowPath.name,
            controllingFieldValue: controllingFieldValue,
            contexts: []
        }
    }

    findNodeByValue(value){
        if(!this.workflowPathConfigurationDto.workflowPath.nodes){
            this.workflowPathConfigurationDto.workflowPath.nodes = [];
            return;
        }
        return this.workflowPathConfigurationDto.workflowPath.nodes.find(node => {
            if (node.controllingFieldValue === value) {
                return node;
            }
        });
    }

    onDeploy() {
        this.enableSpinner();
        deployWorkflowPath({
            configuration: JSON.stringify(this.workflowPathConfigurationDto)
        })
            .then(deploymentProcessId => {
                this.disableSpinner();
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Workflow Path is being deployed, id of the process: ' + deploymentProcessId,
                    variant: 'success'
                }));
            })
            .catch(error => {
                this.disableSpinner();
                const message = error.body ? error.body.message : error;
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: message,
                    variant: 'error'
                }));
            })
    }

    onContextChanged(event){
        const changedWorkflowPathNode = event.detail;
        this.updateNodesInWorkflowPath(changedWorkflowPathNode);
        this.currentWorkFlowPathNode = this.findNodeByValue(changedWorkflowPathNode.controllingFieldValue);
    }

    updateNodesInWorkflowPath(updatedNode){
        const filteredNodes = this.workflowPathConfigurationDto.workflowPath.nodes.filter(node =>{
            return node.controllingFieldValue !== updatedNode.controllingFieldValue;
        });

        filteredNodes.push(updatedNode);
        this.workflowPathConfigurationDto.workflowPath.nodes = filteredNodes;
    }

    onContextTypeChanged(event){
        const contextType = event.detail;
        this.addContextTypeToNewList(contextType);
        this.addUpdatedContextTypeToAllList(contextType);
        this.contextTypes = this.workflowPathConfigurationDto.contextTypes;
    }

    addContextTypeToNewList(newContextType){
        this.workflowPathConfigurationDto.newContextTypes = this.substituteOrAddContextTypeToList(
            this.workflowPathConfigurationDto.newContextTypes,
            newContextType
        );
    }

    addUpdatedContextTypeToAllList(updatedContextType){
        this.workflowPathConfigurationDto.contextTypes = this.substituteOrAddContextTypeToList(
            this.workflowPathConfigurationDto.contextTypes,
            updatedContextType
        );
    }

    substituteOrAddContextTypeToList(contextTypes, newContextType){
        const filteredContextTypes = contextTypes.filter(contextType =>{
            return contextType.name !== newContextType.name;
        });
        filteredContextTypes.push(newContextType);
        return filteredContextTypes;
    }

    enableSpinner(){
        this.showSpinner = true;
    }

    disableSpinner(){
        this.showSpinner = false;
    }
}