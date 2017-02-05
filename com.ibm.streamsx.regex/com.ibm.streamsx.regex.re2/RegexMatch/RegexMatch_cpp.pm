
package RegexMatch_cpp;
use strict; use Cwd 'realpath';  use File::Basename;  use lib dirname(__FILE__);  use SPL::Operator::Instance::OperatorInstance; use SPL::Operator::Instance::Annotation; use SPL::Operator::Instance::Context; use SPL::Operator::Instance::Expression; use SPL::Operator::Instance::ExpressionTree; use SPL::Operator::Instance::ExpressionTreeEvaluator; use SPL::Operator::Instance::ExpressionTreeVisitor; use SPL::Operator::Instance::ExpressionTreeCppGenVisitor; use SPL::Operator::Instance::InputAttribute; use SPL::Operator::Instance::InputPort; use SPL::Operator::Instance::OutputAttribute; use SPL::Operator::Instance::OutputPort; use SPL::Operator::Instance::Parameter; use SPL::Operator::Instance::StateVariable; use SPL::Operator::Instance::TupleValue; use SPL::Operator::Instance::Window; 
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
   
   	my $pattern = ($_ = $model->getParameterByName('pattern')) ? $_->getValueAt(0)->getCppExpression() : '""';
   	my $logErrors = ($_ = $model->getParameterByName('logErrors')) ? $_->getValueAt(0)->getCppExpression() : "true";
   	my $maxMemory = ($_ = $model->getParameterByName('maxMemory')) ? $_->getValueAt(0)->getCppExpression() : 1000000;
   print "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::RegexFullMatch(const string & str) {', "\n";
   print '	return RE2::FullMatch(str, _regex) == 1;', "\n";
   print '}', "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::RegexFullMatch(const string & str, const string & pattern) {', "\n";
   print "\n";
   print '	AutoPortMutex am(_mutex, *this);', "\n";
   print '	if(_regexMap.count(pattern) == 0) {', "\n";
   print '		string pat = pattern;', "\n";
   print '		_regexMap.insert(pat, new RE2(pattern, _options));', "\n";
   print '	}', "\n";
   print "\n";
   print '	return RE2::FullMatch(str, _regexMap.at(pattern)) == 1;', "\n";
   print '}', "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::RegexPartialMatch(const string & str) {', "\n";
   print '	return RE2::PartialMatch(str, _regex) == 1;', "\n";
   print '}', "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::RegexPartialMatch(const string & str, const string & pattern) {', "\n";
   print "\n";
   print '	AutoPortMutex am(_mutex, *this);', "\n";
   print '	if(_regexMap.count(pattern) == 0) {', "\n";
   print '		string pat = pattern;', "\n";
   print '		_regexMap.insert(pat, new RE2(pattern, _options));', "\n";
   print '	}', "\n";
   print "\n";
   print '	return RE2::PartialMatch(str, _regexMap.at(pattern)) == 1;', "\n";
   print '}', "\n";
   print "\n";
   print 'bool MY_OPERATOR_SCOPE::MY_OPERATOR::RegexSimpleMatch(const string & str, const string & pattern) {', "\n";
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
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Tuple const & tuple, uint32_t port) {', "\n";
   print '	IPort0Type const & ';
   print $inTuple;
   print ' = static_cast<IPort0Type const&>(tuple);', "\n";
   print '	OPort0Type * otuplePtr = getOutputTuple();', "\n";
   print "\n";
   print '	';
    foreach my $attribute (@{$outputPort->getAttributes()}) {
   	  my $name = $attribute->getName();
   	  SPL::CodeGen::println($attribute->getAssignmentOutputFunctionName());
   	  if ($attribute->hasAssignmentWithOutputFunction()) {
   		  my $operation = $attribute->getAssignmentOutputFunctionName();
   		  if ($operation eq 'AsIs') {
   			my $init = $attribute->getAssignmentOutputFunctionParameterValueAt(0)->getCppExpression();
   print "\n";
   print '			otuplePtr->set_';
   print $name;
   print '(';
   print $init;
   print ');', "\n";
   print '		  ';
   }
   		  else {
   			my $paramValues = $attribute->getAssignmentOutputFunctionParameterValues();
   print "\n";
   print '			otuplePtr->set_';
   print $name;
   print '(';
   print $operation;
   print '(';
   print join(",", map{$_->getCppExpression()} @$paramValues);
   print '));', "\n";
   print '		  ';
   }
   	  }
   	  elsif ($attribute->getAssignmentValue()) {
   		  my $assign = $attribute->getAssignmentValue()->getCppExpression();
   print "\n";
   print '		  otuplePtr->set_';
   print $name;
   print '(';
   print $assign;
   print ');', "\n";
   print '	  ';
   }
   	}
   print "\n";
   print '	submit(*otuplePtr, 0);', "\n";
   print "\n";
   print '}', "\n";
   print "\n";
   print 'void MY_OPERATOR_SCOPE::MY_OPERATOR::process(Punctuation const & punct, uint32_t port) {', "\n";
   print '   forwardWindowPunctuation(punct);', "\n";
   print '}', "\n";
   print "\n";
   print 'thread_specific_ptr<MY_OPERATOR_SCOPE::MY_OPERATOR::OPort0Type> MY_OPERATOR_SCOPE::MY_OPERATOR::otuplePtr_;', "\n";
   print "\n";
   print 'MY_OPERATOR_SCOPE::MY_OPERATOR::OPort0Type * MY_OPERATOR_SCOPE::MY_OPERATOR::getOutputTuple() {', "\n";
   print '	OPort0Type * otuplePtr = otuplePtr_.get();', "\n";
   print '	if(!otuplePtr) {', "\n";
   print '		otuplePtr_.reset(new OPort0Type());', "\n";
   print '		otuplePtr = otuplePtr_.get();', "\n";
   print '	}', "\n";
   print '	return otuplePtr;', "\n";
   print '}', "\n";
   print "\n";
   SPL::CodeGen::implementationEpilogue($model);
   print "\n";
   CORE::exit $SPL::CodeGen::USER_ERROR if ($SPL::CodeGen::sawError);
}
1;
