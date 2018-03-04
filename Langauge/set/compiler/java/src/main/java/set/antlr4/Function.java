package set.antlr4;

import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;

import set.antlr4.SETParser.ExpressionContext;

public class Function {
	private String id;
    private List<TerminalNode> params;
    private ParseTree block;

    public Function(String id, List<TerminalNode> params, ParseTree block) {
    	this.id = id;
        this.params = params;
        this.block = block;
    }
    
    public SETValue invoke(List<ExpressionContext> params, Map<String, Function> functions, Scope scope) {
        if (params.size() != this.params.size()) {
            throw new RuntimeException("Illegal Function call");
        }
        scope = new Scope(scope); // create function scope
        EvalVisitor evalVisitor = new EvalVisitor(scope, functions); 
        for (int i = 0; i < this.params.size(); i++) {
            SETValue value = evalVisitor.visit(params.get(i));
            scope.assignParam(this.params.get(i).getText(), value);
        }
        SETValue ret = SETValue.VOID;
        try {
        	evalVisitor.visit(this.block);
        } catch (ReturnValue returnValue) {
        	ret = returnValue.value;
        }
        return ret;
    }
}
