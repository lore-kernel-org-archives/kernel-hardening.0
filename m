MIME-Version: 1.0
In-Reply-To: <CAJ1xhMUQXEzjrCyMd9qdu5dm00Ash8d0C7n8Y9JHRg+THW-Q_w@mail.gmail.com>
References: <CAJ1xhMUV8G+-e8fO2MGEWvQGpLVBsETWTpyMZ5wb9evoszZEJg@mail.gmail.com>
 <20171129101640.GC6217@eros> <CAPDLWs8ooetPXhuHXyCLZ2LnPRKBf0CSMoESbXMD4sGnLLNFuA@mail.gmail.com>
 <20171129204812.GE6217@eros> <1512133747.17323.3.camel@gmail.com>
 <20171204001106.GB27780@eros> <1512362481.17323.9.camel@gmail.com>
 <20171204045522.GE27780@eros> <CAPDLWs8biiKptmmYj45mrc+KWrV93JNQP5eLHcgTGznMj_yBow@mail.gmail.com>
 <CAPDLWs-BFQ+NF15ntxFNS4MT2kVs+k9BUYreDZeYEP1sFLQJ+w@mail.gmail.com>
 <20171204082111.GB21565@eros> <1512382841.17323.11.camel@gmail.com> <CAJ1xhMUQXEzjrCyMd9qdu5dm00Ash8d0C7n8Y9JHRg+THW-Q_w@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Mon, 4 Dec 2017 18:58:49 +0530
Message-ID: <CAPDLWs_dASbtmq9yJz9K3_iJp6SkeJxa_qMqqa+Muyhijxu97g@mail.gmail.com>
Content-Type: multipart/alternative; boundary="001a113d0efa0f598e055f83b459"
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add support for 32-bit kernel addresses
To: Alexander Kapshuk <alexander.kapshuk@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a113d0efa0f598e055f83b459
Content-Type: text/plain; charset="UTF-8"

Sure, thanks Alexander..
Tobin, request you to pl make the change while merging, thanks..


Thanks & Regards,
Kaiwan.

On Mon, Dec 4, 2017 at 6:07 PM, Alexander Kapshuk <
alexander.kapshuk@gmail.com> wrote:

> On Mon, Dec 4, 2017 at 12:20 PM,  <kaiwan.billimoria@gmail.com> wrote:
> > On Mon, 2017-12-04 at 19:21 +1100, Tobin C. Harding wrote:
> >> On Mon, Dec 04, 2017 at 10:51:53AM +0530, Kaiwan N Billimoria wrote:
> >> > > ---
> >> > diff --git a/scripts/leaking_addresses.pl b/scripts/
> leaking_addresses.pl
> >> > index 9906dcf8b807..260b52e456f1 100755
> >> > --- a/scripts/leaking_addresses.pl
> >> > +++ b/scripts/leaking_addresses.pl
> >> > @@ -266,7 +266,7 @@ sub is_false_positive
> >> >  sub is_false_positive_ix86_32
> >> >  {
> >> >         my ($match) = @_;
> >> > -       state $page_offset = eval get_page_offset(); # only gets
> called once
> >> > +       state $page_offset = hex get_page_offset(); # only gets
> called once
> >>
> >> I don't think this is valid ;) I meant use hex() to convert the string
> >> to an int so it doesn't throw the warning (inside get_page_offset()).
> >
> > Yup, got it, thanks   :-p
> > Combined patch below:
> >
> >
> > ---
> >  scripts/leaking_addresses.pl | 13 ++++++-------
> >  1 file changed, 6 insertions(+), 7 deletions(-)
> >
> > diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> > index 9906dcf8b807..a595a2c66b12 100755
> > --- a/scripts/leaking_addresses.pl
> > +++ b/scripts/leaking_addresses.pl
> > @@ -266,8 +266,7 @@ sub is_false_positive
> >  sub is_false_positive_ix86_32
> >  {
> >         my ($match) = @_;
> > -       state $page_offset = eval get_page_offset(); # only gets called
> once
> > -
> > +       state $page_offset = get_page_offset(); # only gets called once
> >         if ($match =~ '\b(0x)?(f|F){8}\b') {
> >                 return 1;
> >         }
> > @@ -283,7 +282,7 @@ sub is_false_positive_ix86_32
> >  sub get_page_offset
> >  {
> >         my $page_offset;
> > -       my $default_offset = "0xc0000000";
> > +       my $default_offset = hex("0xc0000000");
> >         my @config_files;
> >
> >         # Allow --page-offset-32bit to override.
> > @@ -306,23 +305,23 @@ sub get_page_offset
> >                 } else {
> >                         $page_offset = parse_kernel_config_file($tmp_
> file);
> >                         if ($page_offset ne "") {
> > -                               return $page_offset;
> > +                               return hex($page_offset);
> >                         }
> >                 }
> >                 system("rm -f $tmp_file");
> >         }
> >
> >         foreach my $config_file (@config_files) {
> > -               $config_file =~ s/\R*//g;
> > +               chomp $config_file;
> >                 $page_offset = parse_kernel_config_file($config_file);
> >                 if ($page_offset ne "") {
> > -                       return $page_offset;
> > +                       return hex($page_offset);
> >                 }
> >         }
> >
> >         printf STDERR "\nFailed to parse kernel config files\n";
> >         printf STDERR "*** NOTE ***\n";
> > -       printf STDERR "Falling back to PAGE_OFFSET = %s\n\n",
> $default_offset;
> > +       printf STDERR "Falling back to PAGE_OFFSET = 0x%x\n\n",
> $default_offset;
>
> Better use the '#' flag with the 'x' conversion specifier:
> perl -e 'my $default_offset = hex("0xc0000000");printf "%#x\n",
> $default_offset'
> 0xc0000000
>
> >
> >         return $default_offset;
> >  }
> > --
> > 2.14.3
> >
> > Thanks,
> > Kaiwan.
> >
> >> thanks,
> >> Tobin.
>

--001a113d0efa0f598e055f83b459
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Sure, thanks Alexander..</div><div clas=
s=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-si=
ze:small">Tobin, request you to pl make the change while merging, thanks..<=
/div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans=
-serif;font-size:small"><br></div></div><div class=3D"gmail_extra"><br clea=
r=3D"all"><div><div class=3D"gmail_signature" data-smartmail=3D"gmail_signa=
ture">Thanks &amp; Regards,<br>Kaiwan.<br></div></div>
<br><div class=3D"gmail_quote">On Mon, Dec 4, 2017 at 6:07 PM, Alexander Ka=
pshuk <span dir=3D"ltr">&lt;<a href=3D"mailto:alexander.kapshuk@gmail.com" =
target=3D"_blank">alexander.kapshuk@gmail.com</a>&gt;</span> wrote:<br><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Mon, =
Dec 4, 2017 at 12:20 PM,=C2=A0 &lt;<a href=3D"mailto:kaiwan.billimoria@gmai=
l.com">kaiwan.billimoria@gmail.com</a>&gt; wrote:<br>
&gt; On Mon, 2017-12-04 at 19:21 +1100, Tobin C. Harding wrote:<br>
&gt;&gt; On Mon, Dec 04, 2017 at 10:51:53AM +0530, Kaiwan N Billimoria wrot=
e:<br>
&gt;&gt; &gt; &gt; ---<br>
&gt;&gt; &gt; diff --git a/scripts/<a href=3D"http://leaking_addresses.pl" =
rel=3D"noreferrer" target=3D"_blank">leaking_addresses.pl</a> b/scripts/<a =
href=3D"http://leaking_addresses.pl" rel=3D"noreferrer" target=3D"_blank">l=
eaking_addresses.pl</a><br>
&gt;&gt; &gt; index 9906dcf8b807..260b52e456f1 100755<br>
&gt;&gt; &gt; --- a/scripts/<a href=3D"http://leaking_addresses.pl" rel=3D"=
noreferrer" target=3D"_blank">leaking_addresses.pl</a><br>
&gt;&gt; &gt; +++ b/scripts/<a href=3D"http://leaking_addresses.pl" rel=3D"=
noreferrer" target=3D"_blank">leaking_addresses.pl</a><br>
&gt;&gt; &gt; @@ -266,7 +266,7 @@ sub is_false_positive<br>
&gt;&gt; &gt;=C2=A0 sub is_false_positive_ix86_32<br>
&gt;&gt; &gt;=C2=A0 {<br>
&gt;&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0my ($match) =3D @_;<br>
&gt;&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0state $page_offset =3D eval get_p=
age_offset(); # only gets called once<br>
&gt;&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0state $page_offset =3D hex get_pa=
ge_offset(); # only gets called once<br>
&gt;&gt;<br>
&gt;&gt; I don&#39;t think this is valid ;) I meant use hex() to convert th=
e string<br>
&gt;&gt; to an int so it doesn&#39;t throw the warning (inside get_page_off=
set()).<br>
&gt;<br>
&gt; Yup, got it, thanks=C2=A0 =C2=A0:-p<br>
&gt; Combined patch below:<br>
&gt;<br>
&gt;<br>
&gt; ---<br>
&gt;=C2=A0 scripts/<a href=3D"http://leaking_addresses.pl" rel=3D"noreferre=
r" target=3D"_blank">leaking_addresses.pl</a> | 13 ++++++-------<br>
&gt;=C2=A0 1 file changed, 6 insertions(+), 7 deletions(-)<br>
&gt;<br>
&gt; diff --git a/scripts/<a href=3D"http://leaking_addresses.pl" rel=3D"no=
referrer" target=3D"_blank">leaking_addresses.pl</a> b/scripts/<a href=3D"h=
ttp://leaking_addresses.pl" rel=3D"noreferrer" target=3D"_blank">leaking_ad=
dresses.pl</a><br>
&gt; index 9906dcf8b807..a595a2c66b12 100755<br>
&gt; --- a/scripts/<a href=3D"http://leaking_addresses.pl" rel=3D"noreferre=
r" target=3D"_blank">leaking_addresses.pl</a><br>
&gt; +++ b/scripts/<a href=3D"http://leaking_addresses.pl" rel=3D"noreferre=
r" target=3D"_blank">leaking_addresses.pl</a><br>
&gt; @@ -266,8 +266,7 @@ sub is_false_positive<br>
&gt;=C2=A0 sub is_false_positive_ix86_32<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0my ($match) =3D @_;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0state $page_offset =3D eval get_page_offse=
t(); # only gets called once<br>
&gt; -<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0state $page_offset =3D get_page_offset(); =
# only gets called once<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ($match =3D~ &#39;\b(0x)?(f|F){8}\=
b&#39;) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; @@ -283,7 +282,7 @@ sub is_false_positive_ix86_32<br>
&gt;=C2=A0 sub get_page_offset<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0my $page_offset;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0my $default_offset =3D &quot;0xc0000000&qu=
ot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0my $default_offset =3D hex(&quot;0xc000000=
0&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0my @config_files;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# Allow --page-offset-32bit to overri=
de.<br>
&gt; @@ -306,23 +305,23 @@ sub get_page_offset<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0$page_offset =3D parse_kernel_config_file($tmp_<wbr>fil=
e);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0if ($page_offset ne &quot;&quot;) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return $page_offset;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return hex($page_offset);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0system(&q=
uot;rm -f $tmp_file&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0foreach my $config_file (@config_file=
s) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$config_file =
=3D~ s/\R*//g;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chomp $config_=
file;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$page_off=
set =3D parse_kernel_config_file($<wbr>config_file);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ($page=
_offset ne &quot;&quot;) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return $page_offset;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return hex($page_offset);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf STDERR &quot;\nFailed to parse=
 kernel config files\n&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf STDERR &quot;*** NOTE ***\n&qu=
ot;;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0printf STDERR &quot;Falling back to PAGE_O=
FFSET =3D %s\n\n&quot;, $default_offset;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0printf STDERR &quot;Falling back to PAGE_O=
FFSET =3D 0x%x\n\n&quot;, $default_offset;<br>
<br>
</div></div>Better use the &#39;#&#39; flag with the &#39;x&#39; conversion=
 specifier:<br>
perl -e &#39;my $default_offset =3D hex(&quot;0xc0000000&quot;);printf &quo=
t;%#x\n&quot;, $default_offset&#39;<br>
0xc0000000<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return $default_offset;<br>
&gt;=C2=A0 }<br>
&gt; --<br>
&gt; 2.14.3<br>
&gt;<br>
&gt; Thanks,<br>
&gt; Kaiwan.<br>
&gt;<br>
&gt;&gt; thanks,<br>
&gt;&gt; Tobin.<br>
</div></div></blockquote></div><br></div>

--001a113d0efa0f598e055f83b459--
