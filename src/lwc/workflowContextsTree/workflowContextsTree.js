import {LightningElement, api, track} from 'lwc';

export default class WorkflowContextsTree extends LightningElement {
    @api
    get contexts() {
        return this.contextsLocal;
    }
    set contexts(value) {
        this.contextsLocal = value ? value.map(this.getClone) : null;
    }
    @api currentContext;

    @track contextsLocal;

    renderedCallback() {
        if (this.currentContext) {
            this.unmarkAllElements();
            this.markElement(this.currentContext.name);
            if (this.currentContext.parentContext) {
                this.displayChildren(this.currentContext.parentContext);
            }
        }
    }

    getClone(value) {
        let result = {...value};
        result['hasChildren'] = !!value.childContexts && value.childContexts.length > 0;
        return result;
    }

    addContext(event) {
        const parentName = event.currentTarget.dataset.name;
        this.dispatchEvent(new CustomEvent('createnewcontext', {detail: {parentName: parentName}}));
    }

    onItemClick(event) {
        const itemName = event.currentTarget.dataset.name;
        this.unmarkAllElements();
        this.markElement(itemName);
        this.dispatchEvent(new CustomEvent('contextselected', {detail: {name: itemName}}));
    }

    handleChildrenVisibility(event) {
        const itemName = event.currentTarget.dataset.parentname;
        this.toggleChildrenVisibility(itemName);
    }

    displayChildren(itemName) {
        this.template.querySelectorAll(`[data-parentname='${itemName}']`).forEach(
            subContext => subContext.classList.remove('slds-hide')
        );
        const parentElement = this.template.querySelector(`[data-name='${itemName}']`);
        if (parentElement) {
            parentElement.firstElementChild.classList.add('slds-hide');
        }
    }

    toggleChildrenVisibility(itemName) {
        this.template.querySelectorAll(`[data-parentname='${itemName}']`).forEach(
            subContext => subContext.classList.toggle('slds-hide')
        );
    }

    unmarkAllElements() {
        this.template.querySelectorAll('.dropdown-menu-item').forEach(
            element => element.classList.remove('selectedItem')
        );
    }

    markElement(itemName) {
        let element = this.template.querySelector(`[data-name='${itemName}']`);
        if (element) {
            element.classList.add('selectedItem');
        }
    }
}