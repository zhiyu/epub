#define  SHEET @"var mySheet = document.styleSheets[0];"
#define  ADDCSSRULE @"function addCSSRule(selector, newRule) {if (mySheet.addRule) {mySheet.addRule(selector, newRule);} else {ruleIndex = mySheet.cssRules.length;mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);}}"
