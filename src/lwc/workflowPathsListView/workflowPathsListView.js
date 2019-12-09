import {LightningElement, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
import {NavigationMixin} from 'lightning/navigation';
import {NamespaceUtils} from 'c/namespaceUtils';

import getWorkflowPaths from '@salesforce/apex/WorkflowPathsListViewController.getWorkflowPaths';

const DATATABLE_COLUMNS = [
    {label: 'Name', type: 'button', sortable: true, fieldName: 'label',
        typeAttributes: {
            label: {fieldName: 'label'},
            name: 'name',
            variant: 'base'
        }
    },
    {label: 'Context Type', fieldName: 'contextType', type: 'text', sortable: true},
    {label: 'Record Type Name', fieldName: 'recordTypeName', type: 'text', sortable: true},
    {label: 'Controlling Field', fieldName: 'controllingField', type: 'text', sortable: true},
    {label: 'Active Status', fieldName: 'activeStatus', type: 'text', sortable: true},
    {label: 'Deployment Status', fieldName: 'deploymentStatus', type: 'text', sortable: true},
    {type: 'action',
        typeAttributes: {
            rowActions: [{
                label: 'Edit', name: 'edit'
            }]
        }
    }
];
const PATH_PAGE = 'WorkflowPathConfigurationContainer';

export default class WorkflowPathsListView extends NavigationMixin(LightningElement) {

    @track showSpinner;

    @track columns = DATATABLE_COLUMNS;
    @track data;

    @track sortedBy;
    @track sortDirection;

    namespaceUtils = new NamespaceUtils();

    connectedCallback() {
        this.runAsyncAction(getWorkflowPaths).then(result => {
            this.data = result.paths;
            NamespaceUtils.namespace = result.namespace;
        }).catch(error => {
            this.showToast(error)
        });
    }

    handleRowAction(event) {
        switch (event.detail.action.name) {
            case 'edit':
                this.handleRowEdit(event);
                break;
            case 'name':
                this.handleNameClick(event);
                break;
            default:
        }
    }

    handleRowEdit(event) {
        let modal = this.template.querySelector('c-workflow-paths-list-view-edit-modal');
        modal.open(event.detail.row.label, event.detail.row.developerName);
    }

    handleNameClick(event) {
        this.navigateToContainer({
            masterLabel: event.detail.row.label,
            developerName: event.detail.row.developerName
        });
    }

    handlePathEdit(event) {
        this.navigateToContainer({
            masterLabel: event.detail.masterLabel,
            developerName: event.detail.developerName
        });
    }

    handleNew(event) {
        let modal = this.template.querySelector('c-workflow-paths-list-view-create-modal');
        modal.open();
    }

    handlePathCreate(event) {
        this.navigateToContainer(event.detail);
    }

    handleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        let sortedData = this.data.sort((a, b) => {
            let getComparedValue = (element) => ((element) ? (element[this.sortedBy] || '') : '');
            let comparision = getComparedValue(a).localeCompare(getComparedValue(b));
            return (this.sortDirection === 'asc') ? comparision : -comparision;
        });
        this.data = [...sortedData];
    }

    showToast(error) {
        let message = (error && error.body) ? error.body.message : error;
        const event = new ShowToastEvent({
            title: 'Error',
            message: message,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }

    navigateToContainer(parameters) {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: this.namespaceUtils.getNamespaceForNavigationScope() + PATH_PAGE
            },
            state: this.fillNavigationScope(parameters)
        })
    }

    fillNavigationScope(parameters) {
        return Object.keys(parameters).reduce((result, key) => {
            let namespacedKey = this.namespaceUtils.getNamespaceForNavigationScope() + key;
            result[namespacedKey] = parameters[key];
            return result;
        }, {});
    }

    runAsyncAction(asyncFunction, parameters) {
        if (asyncFunction) {
            this.showSpinner = true;
            return asyncFunction(parameters).finally(() => {
                this.showSpinner = false;
            })
        }
    }
}