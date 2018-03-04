#include "Main.h"
#include "Scope.h"
#include "Function.h"
#include "SymbolVisitor.h"
#include "EvalVisitor.h"

namespace tl
{
	namespace antlr4
	{
		using org::antlr::v4::runtime::ANTLRFileStream;
		using org::antlr::v4::runtime::CommonTokenStream;
		using org::antlr::v4::runtime::tree::ParseTree;

		void Main::main(std::vector<std::wstring> &args)
		{
			try
			{
				ANTLRFileStream tempVar(L"src/main/tl/test.tl");
				TLLexer *lexer = new TLLexer(&tempVar);
				CommonTokenStream tempVar2(lexer);
				TLParser *parser = new TLParser(&tempVar2);
				parser->setBuildParseTree(true);
				ParseTree *tree = parser->parse();

				Scope *scope = new Scope();
				std::unordered_map<std::wstring, Function*> functions;
				SymbolVisitor *symbolVisitor = new SymbolVisitor(functions);
				symbolVisitor->visit(tree);
				EvalVisitor *visitor = new EvalVisitor(scope, functions);
				visitor->visit(tree);
			}
			catch (std::exception &e)
			{
				if (e.what() != nullptr)
				{
					System::err::println(e.what());
				}
				else
				{
					e.printStackTrace();
				}
			}
		}
	}
}
