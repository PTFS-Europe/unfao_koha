#!/usr/bin/perl
#
use strict;
use warnings;

use lib '/home/koha/kohaclone';
use DBI;
use C4::Context;

$ENV{KOHA_CONF} = '/home/koha/koha-dev/etc/koha-conf.xml';

my $dbh = C4::Context->dbh;

#drop table stat_from_marcxml;
my $create_stmt = <<'ENDSQL';
create table stat_from_marcxml
select
biblioitems.biblionumber,
substr(ExtractValue(biblioitems.marcxml, '//leader'),8,1) as itemtype,
ExtractValue(biblioitems.marcxml,'//datafield[@tag="859"]/subfield[@code="c"]') as cataloguerm,
ExtractValue(biblioitems.marcxml,'//datafield[@tag="923"]/subfield[@code="a"]') as cataloguers,
substr(ExtractValue(biblioitems.marcxml,'//controlfield[@tag="008"]'),1,6) as insertdate,
substr(ExtractValue(biblioitems.marcxml,'//controlfield[@tag="005"]'),1,8) as modifydate,
ExtractValue(biblioitems.marcxml,'//controlfield[@tag="001"]') as accessionno,
ExtractValue(biblioitems.marcxml,'//datafield[@tag="020"]/subfield[@code="a"]') as isbn,
ExtractValue(biblioitems.marcxml,'//datafield[@tag="022"]/subfield[@code="a"]') as issn,
ExtractValue(biblioitems.marcxml,'//datafield[@tag="084"]/subfield[@code="a"]') as callnumber,
ExtractValue(biblioitems.marcxml,'//datafield[@tag="245"]/subfield[@code="a"]') as title
from biblioitems
ENDSQL

$dbh->do('drop table stat_from_marcxml');

my $sth = $dbh->prepare($create_stmt);

$sth->execute();
