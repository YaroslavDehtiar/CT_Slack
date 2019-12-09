import {LightningElement, api, track} from 'lwc';

const actionParametersColumnDefinition = {
    label: 'Parameters',
    type: 'button-icon',
    fixedWidth: 80,
    typeAttributes: {
        iconName: 'utility:preview',
        title: 'Action parameters',
        variant: 'border-filled',
        alternativeText: 'Action parameters',
        name: 'parameters'
    }
};

const actionColumnsByType = new Map([
    ['Record Update', [
        {label: 'Name', fieldName: 'label'},
        {label: 'Context type', fieldName: 'contextTypeDeveloperName'},
        {label: 'Field', fieldName: 'field'},
        {label: 'New value', fieldName: 'newValue'},
        actionParametersColumnDefinition
    ]],
    ['Platform Event', [
        {label: 'Name', fieldName: 'label'},
        {label: 'Context type', fieldName: 'contextTypeDeveloperName'},
        {label: 'Field', fieldName: 'field'},
        {label: 'Event Name', fieldName: 'eventName'},
        actionParametersColumnDefinition
    ]]
]);

const contextActionColumns = [
    {
        label: 'Name',
        fieldName: 'label'
    },
    {
        label: 'Type',
        fieldName: 'type'
    },
    {
        label: 'Order',
        fieldName: 'order',
        type: 'reorder',
        fixedWidth: 100,
        typeAttributes: {
            displayValue: true,
            rowId: {fieldName: 'name'}
        },
    },
    actionParametersColumnDefinition
];

const actionTypes = [
    {label: 'Record Update', value: 'Record Update'},
    {label: 'Platform Event', value: 'Platform Event'}
];

export default class WorkflowContextActions extends LightningElement {
    @api actions;
    @api contextName;

    @api
    get contextActions() {
        return this.contextActionsLocal;
    }
    set contextActions(value) {
        this.contextActionsLocal = JSON.parse(JSON.stringify(value));
        this.sortContextActionsList();
    }
    @track contextActionsLocal;
    @track contextActionsToDisplay;
    @track filteredActionsToAssociate;

    @track contextActionColumns = contextActionColumns;
    @track actionColumns;
    @track actionTypes = actionTypes;
    @track selectedActionType;
    @track searchContextActionValue;
    @track searchActionValue;
    @track actionParameters;

    dispatchContextActionsChangedEvent() {
        this.dispatchEvent(new CustomEvent('contextactionschanged', {
            detail: {
                contextActions: this.contextActionsLocal,
                contextName: this.contextName
            }}));
    }

    filterContextActions() {
        this.contextActionsToDisplay = this.contextActionsLocal.filter(
            contextAction => contextAction.label.toUpperCase().includes(this.searchContextActionValue.toUpperCase())
        ).map(
            contextAction => {
                let contextActionClone = {... contextAction};
                const action = this.findActionByName(contextAction.actionDeveloperName);
                contextActionClone.type = action ? action.type : null;
                return contextActionClone;
            }
        );;
    }

    handleContextActionsSearch(event) {
        this.searchContextActionValue = event.target.value;
        this.filterContextActions();
    }

    handleActionsSearch(event) {
        this.searchActionValue = event.target.value;
        this.filterActions();
    }

    filterActions() {
        const associatedActions = (this.contextActionsLocal || []).map(contextAction => contextAction.actionDeveloperName);
        this.filteredActionsToAssociate = (this.actions || []).filter(
            action => (!this.searchActionValue || action.label.toUpperCase().includes(this.searchActionValue.toUpperCase()))
                && (!this.selectedActionType || action.type === this.selectedActionType)
                && !associatedActions.includes(action.name)
        );
        console.log(this.actions);
    }

    handleMenuSelect(event) {
        this.selectedActionType = event.detail.value;
        this.actionColumns = actionColumnsByType.get(this.selectedActionType);
        this.filterActions();
        this.template.querySelector('.actions-selection-modal').open();
    }

    closeActionsModal() {
        this.searchActionValue = null;
        this.template.querySelector('.actions-selection-modal').close();
    }

    closeParametersModal() {
        this.template.querySelector('.action-parameters-modal').close();
    }

    createContextActions() {
        this.searchValue = '';
        const selectedActions = this.template.querySelector('.actions-list').getSelectedRows();
        let counter = 0;
        selectedActions.forEach(
            action => this.contextActionsLocal.push({
                label: action.label,
                name: this.generateContextActionName(counter++),
                actionDeveloperName: action.name,
                contextDeveloperName: this.contextName,
                order: this.getLastElementOrder() + 1
            })
        );
        this.sortContextActionsList();
        this.dispatchContextActionsChangedEvent();
        this.closeActionsModal();
    }

    getFirstElementOrder() {
        return (this.contextActionsLocal && this.contextActionsLocal.length > 0) ?
            this.contextActionsLocal[0].order :
            0;
    }

    getLastElementOrder() {
        return (this.contextActionsLocal && this.contextActionsLocal.length > 0) ?
            this.contextActionsLocal[this.contextActionsLocal.length-1].order :
            0;
    }

    generateContextActionName(counter) {
        return 'ContextAction_' + (Date.now() + counter).toString();
    }

    handleChangeOrder(event) {
        this.searchValue = '';
        const rowId = event.detail.rowId;
        const direction = event.detail.direction;
        const currentElement = this.findContextActionByName(rowId);
        if (currentElement) {
            let currentOrder = currentElement.order;
            if (direction > 0 && currentOrder < this.getLastElementOrder()) {           //move down
                let nextElement = this.findNextElement(currentElement);
                currentElement.order = nextElement.order;
                nextElement.order = currentOrder;
            } else if (direction < 0 && currentOrder > this.getFirstElementOrder()) {   //move up
                let previousElement = this.findPreviousElement(currentElement);
                currentElement.order = previousElement.order;
                previousElement.order = currentOrder;
            }
            this.sortContextActionsList();
            this.dispatchContextActionsChangedEvent();
        }
    }

    findContextActionByName(name) {
        return this.contextActionsLocal.find(contextAction => contextAction.name === name);
    }

    findPreviousElement(currentElement) {
        let currentElementIndex = this.contextActionsLocal.indexOf(currentElement);
        return currentElementIndex > 0 ? this.contextActionsLocal[currentElementIndex - 1] : null;
    }

    findNextElement(currentElement) {
        let currentElementIndex = this.contextActionsLocal.indexOf(currentElement);
        return currentElementIndex < this.contextActionsLocal.length-1 ? this.contextActionsLocal[currentElementIndex + 1] : null;
    }

    sortContextActionsList() {
        this.contextActionsLocal.sort((a,b) => a.order - b.order);
        this.contextActionsToDisplay = this.contextActionsLocal.map(
            contextAction => {
                let contextActionClone = {... contextAction};
                const action = this.findActionByName(contextAction.actionDeveloperName);
                contextActionClone.type = action ? action.type : null;
                return contextActionClone;
            }
        );
    }

    setContextActionsToDisplay() {

    }

    handleContextActionsTableRowAction(event) {
        const row = event.detail.row;
        this.openActionParametersModal(row.actionDeveloperName);
    }

    handleActionsTableRowAction(event) {
        const row = event.detail.row;
        this.openActionParametersModal(row.name);
    }

    openActionParametersModal(actionName) {
        const action = this.findActionByName(actionName);
        if (action) {
            this.actionParameters = action.parameters ? JSON.parse(action.parameters) : null;
            const modal = this.template.querySelector('.action-parameters-modal');
            modal.overflowScroll();
            modal.open();
        }
    }

    findActionByName(actionName) {
        return this.actions ? this.actions.find(action => action.name === actionName) : null;
    }

}