package set.antlr4;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.misc.NotNull;
import org.antlr.v4.runtime.tree.TerminalNode;

import set.antlr4.SETParser.AndExpressionContext;
import set.antlr4.SETParser.AssertFunctionCallContext;
import set.antlr4.SETParser.BlockContext;
import set.antlr4.SETParser.DivideExpressionContext;
import set.antlr4.SETParser.ExpressionContext;
import set.antlr4.SETParser.ExpressionExpressionContext;
import set.antlr4.SETParser.ForStatementContext;
import set.antlr4.SETParser.FunctionCallExpressionContext;
import set.antlr4.SETParser.FunctionDeclContext;
import set.antlr4.SETParser.GtEqExpressionContext;
import set.antlr4.SETParser.GtExpressionContext;
import set.antlr4.SETParser.IdentifierFunctionCallContext;
import set.antlr4.SETParser.InExpressionContext;
import set.antlr4.SETParser.InputExpressionContext;
import set.antlr4.SETParser.ListContext;
import set.antlr4.SETParser.ListExpressionContext;
import set.antlr4.SETParser.LtEqExpressionContext;
import set.antlr4.SETParser.LtExpressionContext;
import set.antlr4.SETParser.ModulusExpressionContext;
import set.antlr4.SETParser.MultiplyExpressionContext;
import set.antlr4.SETParser.NotExpressionContext;
import set.antlr4.SETParser.OrExpressionContext;
import set.antlr4.SETParser.PowerExpressionContext;
import set.antlr4.SETParser.SizeFunctionCallContext;
import set.antlr4.SETParser.StatementContext;
import set.antlr4.SETParser.SubtractExpressionContext;
import set.antlr4.SETParser.TernaryExpressionContext;
import set.antlr4.SETParser.UnaryMinusExpressionContext;
import set.antlr4.SETParser.WhileStatementContext;

public class EvalVisitor extends SETBaseVisitor<SETValue> {
	private static ReturnValue returnValue = new ReturnValue();
    private Scope scope;
    private Map<String, Function> functions;
    
    public EvalVisitor(Scope scope, Map<String, Function> functions) {
        this.scope = scope;
        this.functions = functions;
    }

    // functionDecl
    @Override
    public SETValue visitFunctionDecl(FunctionDeclContext ctx) {
        return SETValue.VOID;
    }
    
    // list: '[' exprList? ']'
    @Override
    public SETValue visitList(ListContext ctx) {
        List<SETValue> list = new ArrayList<SETValue>();
        if (ctx.exprList() != null) {
	        for(ExpressionContext ex: ctx.exprList().expression()) {
	            list.add(this.visit(ex));
	        }
        }
        return new SETValue(list);
    }
    
    
    // '-' expression                           #unaryMinusExpression
    @Override
    public SETValue visitUnaryMinusExpression(UnaryMinusExpressionContext ctx) {
    	SETValue v = this.visit(ctx.expression());
    	if (!v.isNumber()) {
    	    throw new EvalException(ctx);
        }
    	return new SETValue(-1 * v.asDouble());
    }

    // '!' expression                           #notExpression
    @Override
    public SETValue visitNotExpression(NotExpressionContext ctx) {
    	SETValue v = this.visit(ctx.expression());
    	if(!v.isBoolean()) {
    	    throw new EvalException(ctx);
        }
    	return new SETValue(!v.asBoolean());
    }

    // expression '^' expression                #powerExpression
    @Override
    public SETValue visitPowerExpression(PowerExpressionContext ctx) {
    	SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	if (lhs.isNumber() && rhs.isNumber()) {
    		return new SETValue(Math.pow(lhs.asDouble(), rhs.asDouble()));
    	}
    	throw new EvalException(ctx);
    }

    // expression '*' expression                #multiplyExpression
    @Override
    public SETValue visitMultiplyExpression(MultiplyExpressionContext ctx) {
    	SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	if(lhs == null || rhs == null) {
    		System.err.println("lhs "+ lhs+ " rhs "+rhs);
    	    throw new EvalException(ctx);
    	}
    	
    	// number * number
        if(lhs.isNumber() && rhs.isNumber()) {
            return new SETValue(lhs.asDouble() * rhs.asDouble());
        }

        // string * number
        if(lhs.isString() && rhs.isNumber()) {
            StringBuilder str = new StringBuilder();
            int stop = rhs.asDouble().intValue();
            for(int i = 0; i < stop; i++) {
                str.append(lhs.asString());
            }
            return new SETValue(str.toString());
        }

        // list * number
        if(lhs.isList() && rhs.isNumber()) {
            List<SETValue> total = new ArrayList<SETValue>();
            int stop = rhs.asDouble().intValue();
            for(int i = 0; i < stop; i++) {
                total.addAll(lhs.asList());
            }
            return new SETValue(total);
        }    	
    	throw new EvalException(ctx);
    }

    // expression '/' expression                #divideExpression
    @Override
    public SETValue visitDivideExpression(DivideExpressionContext ctx) {
    	SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	if (lhs.isNumber() && rhs.isNumber()) {
    		return new SETValue(lhs.asDouble() / rhs.asDouble());
    	}
    	throw new EvalException(ctx);
    }

    // expression '%' expression                #modulusExpression
	@Override
	public SETValue visitModulusExpression(ModulusExpressionContext ctx) {
		SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	if (lhs.isNumber() && rhs.isNumber()) {
    		return new SETValue(lhs.asDouble() % rhs.asDouble());
    	}
    	throw new EvalException(ctx);
	}
	
    // expression '+' expression                #addExpression
    @Override
    public SETValue visitAddExpression(@NotNull SETParser.AddExpressionContext ctx) {
        SETValue lhs = this.visit(ctx.expression(0));
        SETValue rhs = this.visit(ctx.expression(1));
        
        if(lhs == null || rhs == null) {
            throw new EvalException(ctx);
        }
        
        // number + number
        if(lhs.isNumber() && rhs.isNumber()) {
            return new SETValue(lhs.asDouble() + rhs.asDouble());
        }
        
        // list + any
        if(lhs.isList()) {
            List<SETValue> list = lhs.asList();
            list.add(rhs);
            return new SETValue(list);
        }

        // string + any
        if(lhs.isString()) {
            return new SETValue(lhs.asString() + "" + rhs.toString());
        }

        // any + string
        if(rhs.isString()) {
            return new SETValue(lhs.toString() + "" + rhs.asString());
        }
        
        return new SETValue(lhs.toString() + rhs.toString());
    }

    // expression '-' expression                #subtractExpression
    @Override
    public SETValue visitSubtractExpression(SubtractExpressionContext ctx) {
    	SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	if (lhs.isNumber() && rhs.isNumber()) {
    		return new SETValue(lhs.asDouble() - rhs.asDouble());
    	}
    	if (lhs.isList()) {
            List<SETValue> list = lhs.asList();
            list.remove(rhs);
            return new SETValue(list);
        }
    	throw new EvalException(ctx);
    }

    // expression '>=' expression               #gtEqExpression
    @Override
    public SETValue visitGtEqExpression(GtEqExpressionContext ctx) {
    	SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	if (lhs.isNumber() && rhs.isNumber()) {
    		return new SETValue(lhs.asDouble() >= rhs.asDouble());
    	}
    	if(lhs.isString() && rhs.isString()) {
            return new SETValue(lhs.asString().compareTo(rhs.asString()) >= 0);
        }
    	throw new EvalException(ctx);
    }

    // expression '<=' expression               #ltEqExpression
    @Override
    public SETValue visitLtEqExpression(LtEqExpressionContext ctx) {
    	SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	if (lhs.isNumber() && rhs.isNumber()) {
    		return new SETValue(lhs.asDouble() <= rhs.asDouble());
    	}
    	if(lhs.isString() && rhs.isString()) {
            return new SETValue(lhs.asString().compareTo(rhs.asString()) <= 0);
        }
    	throw new EvalException(ctx);
    }

    // expression '>' expression                #gtExpression
    @Override
    public SETValue visitGtExpression(GtExpressionContext ctx) {
    	SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	if (lhs.isNumber() && rhs.isNumber()) {
    		return new SETValue(lhs.asDouble() > rhs.asDouble());
    	}
    	if(lhs.isString() && rhs.isString()) {
            return new SETValue(lhs.asString().compareTo(rhs.asString()) > 0);
        }
    	throw new EvalException(ctx);
    }

    // expression '<' expression                #ltExpression
    @Override
    public SETValue visitLtExpression(LtExpressionContext ctx) {
    	SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	if (lhs.isNumber() && rhs.isNumber()) {
    		return new SETValue(lhs.asDouble() < rhs.asDouble());
    	}
    	if(lhs.isString() && rhs.isString()) {
            return new SETValue(lhs.asString().compareTo(rhs.asString()) < 0);
        }
    	throw new EvalException(ctx);
    }

    // expression '==' expression               #eqExpression
    @Override
    public SETValue visitEqExpression(@NotNull SETParser.EqExpressionContext ctx) {
        SETValue lhs = this.visit(ctx.expression(0));
        SETValue rhs = this.visit(ctx.expression(1));
        if (lhs == null) {
        	throw new EvalException(ctx);
        }
        return new SETValue(lhs.equals(rhs));
    }

    // expression '!=' expression               #notEqExpression
    @Override
    public SETValue visitNotEqExpression(@NotNull SETParser.NotEqExpressionContext ctx) {
        SETValue lhs = this.visit(ctx.expression(0));
        SETValue rhs = this.visit(ctx.expression(1));
        return new SETValue(!lhs.equals(rhs));
    }

    // expression '&&' expression               #andExpression
    @Override
    public SETValue visitAndExpression(AndExpressionContext ctx) {
    	SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	
    	if(!lhs.isBoolean() || !rhs.isBoolean()) {
    	    throw new EvalException(ctx);
        }
		return new SETValue(lhs.asBoolean() && rhs.asBoolean());
    }

    // expression '||' expression               #orExpression
    @Override
    public SETValue visitOrExpression(OrExpressionContext ctx) {
    	SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	
    	if(!lhs.isBoolean() || !rhs.isBoolean()) {
    	    throw new EvalException(ctx);
        }
		return new SETValue(lhs.asBoolean() || rhs.asBoolean());
    }

    // expression '?' expression ':' expression #ternaryExpression
    @Override
    public SETValue visitTernaryExpression(TernaryExpressionContext ctx) {
    	SETValue condition = this.visit(ctx.expression(0));
    	if (condition.asBoolean()) {
    		return new SETValue(this.visit(ctx.expression(1)));
    	} else {
    		return new SETValue(this.visit(ctx.expression(2)));
    	}
    }

    // expression In expression                 #inExpression
	@Override
	public SETValue visitInExpression(InExpressionContext ctx) {
		SETValue lhs = this.visit(ctx.expression(0));
    	SETValue rhs = this.visit(ctx.expression(1));
    	
    	if (rhs.isList()) {
    		for(SETValue val: rhs.asList()) {
    			if (val.equals(lhs)) {
    				return new SETValue(true);
    			}
    		}
    		return new SETValue(false);
    	}
    	throw new EvalException(ctx);
	}
	
    // Number                                   #numberExpression
    @Override
    public SETValue visitNumberExpression(@NotNull SETParser.NumberExpressionContext ctx) {
        return new SETValue(Double.valueOf(ctx.getText()));
    }

    // Bool                                     #boolExpression
    @Override
    public SETValue visitBoolExpression(@NotNull SETParser.BoolExpressionContext ctx) {
        return new SETValue(Boolean.valueOf(ctx.getText()));
    }

    // Null                                     #nullExpression
    @Override
    public SETValue visitNullExpression(@NotNull SETParser.NullExpressionContext ctx) {
        return SETValue.NULL;
    }

    private SETValue resolveIndexes(ParserRuleContext ctx, SETValue val, List<ExpressionContext> indexes) {
    	for (ExpressionContext ec: indexes) {
    		SETValue idx = this.visit(ec);
    		if (!idx.isNumber() || (!val.isList() && !val.isString()) ) {
        		throw new EvalException("Problem resolving indexes on "+val+" at "+idx, ec);
    		}
    		int i = idx.asDouble().intValue();
    		if (val.isString()) {
    			val = new SETValue(val.asString().substring(i, i+1));
    		} else {
    			val = val.asList().get(i);
    		}
    	}
    	return val;
    }
    
    private void setAtIndex(ParserRuleContext ctx, List<ExpressionContext> indexes, SETValue val, SETValue newVal) {
    	if (!val.isList()) {
    		throw new EvalException(ctx);
    	}
    	// TODO some more list size checking in here
    	for (int i = 0; i < indexes.size() - 1; i++) {
    		SETValue idx = this.visit(indexes.get(i));
    		if (!idx.isNumber()) {
        		throw new EvalException(ctx);
    		}
    		val = val.asList().get(idx.asDouble().intValue());
    	}
    	SETValue idx = this.visit(indexes.get(indexes.size() - 1));
		if (!idx.isNumber()) {
    		throw new EvalException(ctx);
		}
    	val.asList().set(idx.asDouble().intValue(), newVal);
    }
    
    // functionCall indexes?                    #functionCallExpression
    @Override
    public SETValue visitFunctionCallExpression(FunctionCallExpressionContext ctx) {
    	SETValue val = this.visit(ctx.functionCall());
    	if (ctx.indexes() != null) {
        	List<ExpressionContext> exps = ctx.indexes().expression();
        	val = resolveIndexes(ctx, val, exps);
        }
    	return val;
    }

    // list indexes?                            #listExpression
    @Override
    public SETValue visitListExpression(ListExpressionContext ctx) {
    	SETValue val = this.visit(ctx.list());
    	if (ctx.indexes() != null) {
        	List<ExpressionContext> exps = ctx.indexes().expression();
        	val = resolveIndexes(ctx, val, exps);
        }
    	return val;
    }

    // Identifier indexes?                      #identifierExpression
    @Override
    public SETValue visitIdentifierExpression(@NotNull SETParser.IdentifierExpressionContext ctx) {
        String id = ctx.Identifier().getText();
        SETValue val = scope.resolve(id);
        
        if (ctx.indexes() != null) {
        	List<ExpressionContext> exps = ctx.indexes().expression();
        	val = resolveIndexes(ctx, val, exps);
        }
        return val;
    }

    // String indexes?                          #stringExpression
    @Override
    public SETValue visitStringExpression(@NotNull SETParser.StringExpressionContext ctx) {
        String text = ctx.getText();
        text = text.substring(1, text.length() - 1).replaceAll("\\\\(.)", "$1");
        SETValue val = new SETValue(text);
        if (ctx.indexes() != null) {
        	List<ExpressionContext> exps = ctx.indexes().expression();
        	val = resolveIndexes(ctx, val, exps);
        }
        return val;
    }

    // '(' expression ')' indexes?              #expressionExpression
    @Override
    public SETValue visitExpressionExpression(ExpressionExpressionContext ctx) {
        SETValue val = this.visit(ctx.expression());
        if (ctx.indexes() != null) {
        	List<ExpressionContext> exps = ctx.indexes().expression();
        	val = resolveIndexes(ctx, val, exps);
        }
        return val;
    }

    // Input '(' String? ')'                    #inputExpression
    @Override
    public SETValue visitInputExpression(InputExpressionContext ctx) {
    	TerminalNode inputString = ctx.String();
		try {
			if (inputString != null) {
				String text = inputString.getText();
		        text = text.substring(1, text.length() - 1).replaceAll("\\\\(.)", "$1");
				return new SETValue(new String(Files.readAllBytes(Paths.get(text))));
			} else {
				BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));
				return new SETValue(buffer.readLine());
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
    }

    
    // assignment
    // : Identifier indexes? '=' expression
    // ;
    @Override
    public SETValue visitAssignment(@NotNull SETParser.AssignmentContext ctx) {
        SETValue newVal = this.visit(ctx.expression());
        if (ctx.indexes() != null) {
        	SETValue val = scope.resolve(ctx.Identifier().getText());
        	List<ExpressionContext> exps = ctx.indexes().expression();
        	setAtIndex(ctx, exps, val, newVal);
        } else {
        	String id = ctx.Identifier().getText();        	
        	scope.assign(id, newVal);
        }
        return SETValue.VOID;
    }

    // Identifier '(' exprList? ')' #identifierFunctionCall
    @Override
    public SETValue visitIdentifierFunctionCall(IdentifierFunctionCallContext ctx) {
        List<ExpressionContext> params = ctx.exprList() != null ? ctx.exprList().expression() : new ArrayList<ExpressionContext>();
        String id = ctx.Identifier().getText() + params.size();
        Function function;      
        if ((function = functions.get(id)) != null) {
            return function.invoke(params, functions, scope);
        }
        throw new EvalException(ctx);
    }

    // Println '(' expression? ')'  #printlnFunctionCall
    @Override
    public SETValue visitPrintlnFunctionCall(@NotNull SETParser.PrintlnFunctionCallContext ctx) {
        System.out.println(this.visit(ctx.expression()));
        return SETValue.VOID;
    }

    // Print '(' expression ')'     #printFunctionCall
    @Override
    public SETValue visitPrintFunctionCall(@NotNull SETParser.PrintFunctionCallContext ctx) {
        System.out.print(this.visit(ctx.expression()));
        return SETValue.VOID;
    }

    // Assert '(' expression ')'    #assertFunctionCall
    @Override
    public SETValue visitAssertFunctionCall(AssertFunctionCallContext ctx) {
    	SETValue value = this.visit(ctx.expression());

        if(!value.isBoolean()) {
            throw new EvalException(ctx);
        }

        if(!value.asBoolean()) {
            throw new AssertionError("Failed Assertion "+ctx.expression().getText()+" line:"+ctx.start.getLine());
        }

        return SETValue.VOID;
    }

    // Size '(' expression ')'      #sizeFunctionCall
    @Override
    public SETValue visitSizeFunctionCall(SizeFunctionCallContext ctx) {
    	SETValue value = this.visit(ctx.expression());

        if(value.isString()) {
            return new SETValue(value.asString().length());
        }

        if(value.isList()) {
            return new SETValue(value.asList().size());
        }

        throw new EvalException(ctx);
    }

    // ifStatement
    //  : ifStat elseIfStat* elseStat? End
    //  ;
    //
    // ifStat
    //  : If expression Do block
    //  ;
    //
    // elseIfStat
    //  : Else If expression Do block
    //  ;
    //
    // elseStat
    //  : Else Do block
    //  ;
    @Override
    public SETValue visitIfStatement(@NotNull SETParser.IfStatementContext ctx) {

        // if ...
        if(this.visit(ctx.ifStat().expression()).asBoolean()) {
            return this.visit(ctx.ifStat().block());
        }

        // else if ...
        for(int i = 0; i < ctx.elseIfStat().size(); i++) {
            if(this.visit(ctx.elseIfStat(i).expression()).asBoolean()) {
                return this.visit(ctx.elseIfStat(i).block());
            }
        }

        // else ...
        if(ctx.elseStat() != null) {
            return this.visit(ctx.elseStat().block());
        }

        return SETValue.VOID;
    }
    
    // block
    // : (statement | functionDecl)* (Return expression)?
    // ;
    @Override
    public SETValue visitBlock(BlockContext ctx) {
    		
    	scope = new Scope(scope); // create new local scope
        for (StatementContext sx: ctx.statement()) {
            this.visit(sx);
        }
        ExpressionContext ex;
        if ((ex = ctx.expression()) != null) {
        	returnValue.value = this.visit(ex);
        	scope = scope.parent();
        	throw returnValue;
        }
        scope = scope.parent();
        return SETValue.VOID;
    }
    
    // forStatement
    // : For Identifier '=' expression To expression OBrace block CBrace
    // ;
    @Override
    public SETValue visitForStatement(ForStatementContext ctx) {
        int start = this.visit(ctx.expression(0)).asDouble().intValue();
        int stop = this.visit(ctx.expression(1)).asDouble().intValue();
        for(int i = start; i <= stop; i++) {
            scope.assign(ctx.Identifier().getText(), new SETValue(i));
            SETValue returnValue = this.visit(ctx.block());
            if(returnValue != SETValue.VOID) {
                return returnValue;
            }
        }
        return SETValue.VOID;
    }
    
    // whileStatement
    // : While expression OBrace block CBrace
    // ;
    @Override
    public SETValue visitWhileStatement(WhileStatementContext ctx) {
        while( this.visit(ctx.expression()).asBoolean() ) {
            SETValue returnValue = this.visit(ctx.block());
            if (returnValue != SETValue.VOID) {
                return returnValue;
            }
        }
        return SETValue.VOID;
    }
    
}
