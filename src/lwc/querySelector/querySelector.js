/**
 * Created by YaroslavDehtiar on 16.10.2019.
 */

import {LightningElement, track, api, wire} from 'lwc';
import getObjects from '@salesforce/apex/QueryBuilder.getObjects';
import getFields from '@salesforce/apex/QueryBuilder.getFields';
import getAllTypesFromObject from '@salesforce/apex/QueryBuilder.getAllTypesFromObject';
import finalExecute from '@salesforce/apex/QueryBuilder.finalExecute';

export default class QuerySelector extends LightningElement {

    @track objects = [];
    @track fields = [];
    @track fieldsWithTypes = [];
    @track disabledFilterButton = true;
    @track disabledExecuteButton = true;
    @track mainObject;
    @track newFields;
    @track listOfTypes;
    @track fieldsFromExecute;
    @track inputs;
    @track inputIds;
    @track setOfInputIds;
    @track inputValues;
    @track components;
    @track comparisonField;
    @track finalString;
    @track error;
    // <aura:handler name="sendInput" action="{!c.createFilter}" event="c:setInputs"/>

    @wire(getObjects)
    wiredContacts({data}) {
        if (data) {
            for (let dataValues of data) {
                this.objects = [...this.objects, {value: dataValues, label: dataValues}];
            }
        }
    }

    get objectOptions() {
        return this.objects;
    }

    handleOptionSelected(event) {
        this.mainObject = event.detail.value;
        getFields({objectName: this.mainObject})
            .then(result => {
                for (let resultElement in result) {
                    this.fields = [...this.fields,
                        {value: resultElement, label: resultElement}];
                    this.fieldsWithTypes = [...this.fieldsWithTypes,
                        {value: result[resultElement], label: resultElement}];
                }
            })
            .catch(error => {
                this.error = error;
            });
        getAllTypesFromObject({getObject: this.mainObject})
            .then(result => {
                for (let resultElement in result) {
                    this.listOfTypes = [...this.listOfTypes,
                        {value: resultElement, label: resultElement}];
                }
            })
            .catch(error => {
                this.error = error;
            });
        this.disabledFilterButton = false;

    }

    get fieldListOptions(){
        return this.fieldsWithTypes;
    }

    choiceFields(event){
        this.newFields = event.detail.value;
        this.newFields != '' ? this.disabledExecuteButton = false : this.disabledExecuteButton = true;
    }

    executeQuery() {
        finalExecute({objectName: this.mainObject, fieldList: this.newFields})
            .then(result => {
                this.fieldsFromExecute = result;
                let parentBranches = [];
                let parentKeys = Object.keys(result);
                // console.log(Object.keys(result));
                // console.log(result[Object.keys(result)[0]]);
                for (let index = 0; index < parentKeys.length; index++) {
                    let parentValue = result[parentKeys[index]];
                    let childBranches = [];
                    let childKeys = Object.keys(parentValue);
                    for (let secondIndex = 0; secondIndex < childKeys.length; secondIndex++) {
                        let childValue = parentValue[childKeys[secondIndex]];
                        let secondChildLabel = childKeys[secondIndex] + ": " + childValue;
                        childBranches = [...childBranches,{
                          label: secondChildLabel,
                          name: parentValue.Id + childKeys[secondIndex],
                          items: []
                        }];
                    }
                    let parentLabel = parentValue.Id;
                    let parentName = parentValue.Id;
                    parentBranches = [...parentBranches, {
                        label: parentLabel,
                        name:parentName,
                        items: childBranches
                    }];
                }
                this.fieldsFromExecute = parentBranches;
            })
            .catch(error => {
                this.error= error;
            })
    }



    // createFilter(component, event, helper) {
    //     const comparison = component.find("comparison");
    //     comparison.set("v.disabled", false);
    //     const getIds = component.get("v.inputIds");
        // $A.createComponent(
        //     "c:Inputs",
        //     {
        //         "inpFieldList": component.get("v.fieldsWithTypes"),
        //         "aura:id": getIds + 1,
        //         "typeList": component.get("v.listOfTypes"),
        //     },
        //     function (newInput, status, errorMessage) {
        //         if (status === "SUCCESS") {
        //             var body = component.get("v.inputs");
        //             body.push(newInput);
        //             component.set("v.inputs", body);
        //         } else if (status === "INCOMPLETE") {
        //             console.log("No response from server or client is offline.")
        //         } else if (status === "ERROR") {
        //             console.log("Error: " + errorMessage);
        //         }
        //     }
        // );
    //     component.set("v.inputIds", getIds + 1);
    //     const arr = component.get("v.setOfInputIds");
    //     arr.push(getIds + 1);
    //     component.set("v.setOfInputIds", arr);
    //     const child = component.find("sendFields");
    //     child.inputFieldsFromParent(component.get("v.fieldList"));
    // }
    //
    // createComparisonOperator(component) {
        // $A.createComponent(
        //     "lightning:input",
        //     {
        //         "aura:id": "comparisonInput",
        //         "label": "Insert operators \"AND\", \"OR\"",
        //     },
        //     function (newField, status) {
        //         if (status === "SUCCESS") {
        //             const body = component.get("v.comparisonField");
        //             body.push(newField);
        //             component.set("v.comparisonField", body);
        //         }
        //     }
        // )
    // }
    //
    //
    // executeQuery(component, event) {
    //     const getArrayOfIds = component.get("v.setOfInputIds");
    //     const finalArr = [];
    //     let comparisonValue;
    //     const comparisonArray = [];
    //     const comparisonId = component.find("comparisonInput");
    //     if (comparisonId) {
    //         comparisonValue = comparisonId.get("v.value");
    //         // console.log(comparisonValue);
    //         for (const getIds of getArrayOfIds) {
    //             const getComponentById = component.find(getIds);
    //
    //             if (getComponentById) {
    //                 const allComponents = getComponentById.find("fieldsInput");
    //                 const arr = [];
    //                 if (finalArr.length > 1) {
    //                     finalArr.push('AND');
    //                 }
    //                 for (let currentComponent of allComponents) {
    //                     const getValue = currentComponent.get("v.value");
    //                     const labelForValue = component.get("v.fieldsWithTypes")
    //                         .reduce((acc, val) => acc || (val.value == getValue ? val.label : ""), "");
    //                     if (getValue !== 'Custom Date') {
    //                         arr.push(getValue);
    //                     }
    //                     if (labelForValue) {
    //                         arr.push(labelForValue);
    //                     }
    //                 }
    //                 if (arr[0] === 'DATETIME') {
    //                     arr[3] = arr[3] + 'T00:00:00Z';
    //                 }
    //                 if (arr[0] !== "DATETIME" && arr[0] !== "BOOLEAN") {
    //                     arr[3] = '\'' + arr[3] + '\'';
    //                 }
    //                 arr.splice(0, 1);
    //                 comparisonArray.push(arr);
    //             }
    //             component.set("v.finalString", finalArr);
    //         }
    //     }
    //
    //     function replacer(match, p1, p2, p3) {
    //         return [p1, p2, p3].join(' ');
    //     }
    //
    //     if (comparisonValue) {
    //         const newArr = [];
    //         let newString = comparisonValue.replace(/([^\d]*)(\d*)([^\w]*)/gm, replacer).split(' ');
    //         for (let newStringElement of newString) {
    //             if (newStringElement !== '') {
    //                 if (Number.isInteger(parseInt(newStringElement))) {
    //                     for (let argument of comparisonArray[newStringElement - 1]) {
    //                         newArr.push(argument)
    //                     }
    //                 } else {
    //                     newArr.push(newStringElement);
    //                 }
    //             }
    //         }
    //         console.log(newArr);
    //         component.set("v.finalString", newArr);
    //     }
    //
    //     const action = component.get("c.finalExecute");
    //     action.setParams({
    //         objectName: component.get("v.mainObject"),
    //         fieldList: component.get("v.newFields"),
    //         filterStrings: component.get("v.finalString")
    //     });
    //
    //     action.setCallback(this, function (resp) {
    //         var data = resp.getReturnValue();
    //         var parentBranches = [];
    //         var parentKeys = Object.keys(data);
    //         for (var i = 0; i < parentKeys.length; i++) {
    //             var parentValue = data[parentKeys[i]];
    //             var childBranches = [];
    //             var childKeys = Object.keys(parentValue);
    //             for (var j = 0; j < childKeys.length; j++) {
    //                 var childValue = parentValue[childKeys[j]];
    //                 var secondChildLabel = childKeys[j] + ": " + childValue;
    //                 childBranches.push({
    //                     label: secondChildLabel,
    //                     name: parentValue.Id + childKeys[j],
    //                     items: []
    //                 });
    //             }
    //             var parentLabel = parentValue.Id;
    //             var parentName = parentValue.Id;
    //             parentBranches.push({
    //                 label: parentLabel,
    //                 name: parentName,
    //                 items: childBranches
    //             });
    //         }
    //         component.set("v.fieldForExecute", parentBranches);
    //     });
    //     component.set("v.finalString", []);
    //     console.log(component.get("v.finalString"));
    // }
}