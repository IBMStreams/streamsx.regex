
package RegexMatchFused_cpp;
use strict; use Cwd 'realpath';  use File::Basename;  use lib dirname(__FILE__);  use SPL::Operator::Instance::OperatorInstance; use SPL::Operator::Instance::Context; use SPL::Operator::Instance::Expression; use SPL::Operator::Instance::ExpressionTree; use SPL::Operator::Instance::ExpressionTreeVisitor; use SPL::Operator::Instance::ExpressionTreeCppGenVisitor; use SPL::Operator::Instance::InputAttribute; use SPL::Operator::Instance::InputPort; use SPL::Operator::Instance::OutputAttribute; use SPL::Operator::Instance::OutputPort; use SPL::Operator::Instance::Parameter; use SPL::Operator::Instance::StateVariable; use SPL::Operator::Instance::Window; 
sub main::generate($$) {
   my ($xml, $signature) = @_;  
   print "// $$signature\n";
   my $model = SPL::Operator::Instance::OperatorInstance->new($$xml);
   unshift @INC, dirname ($model->getContext()->getOperatorDirectory()) . "/../impl/nl/include";
   $SPL::CodeGenHelper::verboseMode = $model->getContext()->isVerboseModeOn();
   SPL::CodeGen::implementationPrologue($model);
   print "\n";
   print "\n";
   	my $inputPort = $model->getInputPortAt(0);
   	my $outputPort = $model->getOutputPortAt(0);
   	my $inTuple = $inputPort->getCppTupleName();
   
   	my $patternParam = $model->getParameterByName("pattern");
   	my $pattern = (defined $patternParam) ? $patternParam->getValueAt(0)->getCppExpression() : '""';
   
   	my $maxMemoryParam = $model->getParameterByName("maxMemory");
   	my $maxMemory = (defined $maxMemoryParam) ? $maxMemoryParam->getValueAt(0)->getCppExpression() : 1000000;
   
   	my $logErrorsParam = $model->getParameterByName("logErrors");
   	my $logErrors = (defined $logErrorsParam) ? $logErrorsParam->getValueAt(0)->getCppExpression() : "true";
   
   	my $regexFunctionParam = $model->getParameterByName("regexFunction");
   	my $regexFunction = (defined $regexFunctionParam) ? $regexFunctionParam->getValueAt(0)->getSPLExpression() : "regexPartialMatch";
   
   	my $patternAttrParam = $model->getParameterByName("patternAttr");
   	my $patternAttr = (defined $patternAttrParam) ? $patternAttrParam->getValueAt(0)->getCppExpression() : '""';
   
   	my $searchAttrParam = $model->getParameterByName("searchAttr");
   	my $searchAttr = $searchAttrParam->getValueAt(0)->getCppExpression();
   
   	my $resultAttrParam = $model->getParameterByName("resultAttr");
   	my $resultAttr = $resultAttrParam->getValueAt(0)->getCppExpression();
   	my $resultType = $resultAttrParam->getValueAt(0)->getCppType();
   print "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::regexFullMatch(const string & str) {', "\n";
   print '	return RE2::FullMatch(str, _regex) == 1;', "\n";
   print '}', "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::regexFullMatch(const string & str, const string & pattern) {', "\n";
   print "\n";
   print '	if(_regexMap.count(pattern) == 0) {', "\n";
   print '		AutoPortMutex am(_mutex, *this);', "\n";
   print '		string pat = pattern;', "\n";
   print '		_regexMap.insert(pat, new RE2(pattern, _options));', "\n";
   print '	}', "\n";
   print "\n";
   print '	return RE2::FullMatch(str, _regexMap.at(pattern)) == 1;', "\n";
   print '}', "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::regexPartialMatch(const string & str) {', "\n";
   print '	return RE2::PartialMatch(str, _regex) == 1;', "\n";
   print '}', "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::regexPartialMatch(const string & str, const string & pattern) {', "\n";
   print "\n";
   print '	if(_regexMap.count(pattern) == 0) {', "\n";
   print '		AutoPortMutex am(_mutex, *this);', "\n";
   print '		string pat = pattern;', "\n";
   print '		_regexMap.insert(pat, new RE2(pattern, _options));', "\n";
   print '	}', "\n";
   print "\n";
   print '	return RE2::PartialMatch(str, _regexMap.at(pattern)) == 1;', "\n";
   print '}', "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::regexSimpleMatch(const string & str) {', "\n";
   print '	return RE2::PartialMatch(str, ';
   print $pattern;
   print ') == 1;', "\n";
   print '}', "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::regexSimpleMatch(const string & str, const string & pattern) {', "\n";
   print '	return RE2::PartialMatch(str, pattern) == 1;', "\n";
   print '}', "\n";
   print "\n";
   print 'MY_OPERATOR_SCOPE::MY_OPERATOR::MY_OPERATOR() : _options(), _regex(';
   print $pattern;
   print ', _options) {', "\n";
   print '	_options.set_log_errors(';
   print $logErrors;
   print ');', "\n";
   print '	_options.set_max_mem(';
   print $maxMemory;
   print ');', "\n";
   print '}', "\n";
   print "\n";
   print 'MY_OPERATOR_SCOPE::MY_OPERATOR::~MY_OPERATOR() {}', "\n";
   print "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Tuple & tuple, uint32_t port) {', "\n";
   print '	IPort0Type & ';
   print $inTuple;
   print ' = static_cast<IPort0Type &>(tuple);', "\n";
   print "\n";
   print '	';
   print $resultType;
   print ' * result = &';
   print $resultAttr;
   print ';', "\n";
   print '	';
    if (not $patternAttrParam) {
   print "\n";
   print '		*result = ';
   print $regexFunction;
   print '(';
   print $searchAttr;
   print ');', "\n";
   print '	';
   } else {
   print "\n";
   print '		*result = ';
   print $regexFunction;
   print '(';
   print $searchAttr;
   print ', ';
   print $patternAttr;
   print ');', "\n";
   print '	';
   }
   print "\n";
   print '}', "\n";
   print "\n";
   SPL::CodeGen::implementationEpilogue($model);
   print "\n";
   CORE::exit $SPL::CodeGen::USER_ERROR if ($SPL::CodeGen::sawError);
}
1;
