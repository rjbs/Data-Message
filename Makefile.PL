use ExtUtils::MakeMaker;

WriteMakefile(
  NAME          => 'Data::Message',
  VERSION_FROM  => 'lib/Data/Message.pm',
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM     => {
    'Test::More'    => '0.47',
    'Email::Simple' => '1.92',
  },
);
