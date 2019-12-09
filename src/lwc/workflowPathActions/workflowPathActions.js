import { LightningElement, api, track } from 'lwc';


export default class WorkflowPathActions extends LightningElement {

    @api
    get actions() {
        return this._actions;
    }
    set actions(value) {
        this.setAttribute('actions', value);
        this._actions = value;
        this.initializeWorkflowPathActions();
    }

    @track _actions;

    firstAction;
    actionsExceptFirst;
    actionByIds;

    connectedCallback() {
        this.initializeWorkflowPathActions();
    }

    initializeWorkflowPathActions() {
        if(!this.actions){
            this.actions = [];
        }
        if (this.actions.length > 0) {
            this.firstAction = this.actions[0];
            this.actionsExceptFirst = this.actions.slice(1);
            this.initializeActionsByIds();
        }
    }

    initializeActionsByIds() {
        let actionByIds = this.actions.reduce(function(map, action) {
            map[action.id] = action;
            return map;
        }, {});
        this.actionByIds = actionByIds;
    }

    onMenuActionItemSelect(event) {
        this.fireActionEvent(event.detail.value);
    }

    onListActionButtonClick(event) {
        this.fireActionEvent(event.currentTarget.value);
    }

    fireActionEvent(actionId) {
        const newExpertEvent = new CustomEvent('buttonclick', {
            detail: this.actionByIds[actionId],
        });
        this.dispatchEvent(newExpertEvent);
    }

    get isGroupOfActions() {
        return this.actions.length > 1;
    }

    get container() {
        return (this.actions.length > 2 ? 'slds-hide ' : this.actions.length == 1 ? '' : 'slds-path__action-list ') + 'slds-grid slds-path__action';
    }

    get actionMenu() {
        return (this.actions.length < 3 ? 'slds-path__action-menu ' : '') + 'slds-path__action-list slds-grid slds-col';
    }

}