import {QuerySelector} from 'c/querySelector';

describe('Test methods for soqlBuilder', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    })
});
it('test Select from soql object methods', () => {
    let soql = new QuerySelector();

    //send discount object to element which loads this.discount
    expect(soql.select(['Id']).from('Account').toSOQLObject()).toEqual({ fields: [ 'Id' ], objectName: 'Account', conditions: [] });
});