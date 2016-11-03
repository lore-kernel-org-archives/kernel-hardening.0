Reply-To: kernel-hardening@lists.openwall.com
Content-Type: multipart/alternative; boundary="Apple-Mail=_63E99C19-F13F-478C-B53C-4732758A9858"
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
From: Dave Tian <dave.jing.tian@gmail.com>
In-Reply-To: <7e3957d4-9729-63cc-dea7-c27e842a6e87@yuhu.biz>
Date: Wed, 2 Nov 2016 22:30:08 -0400
Message-Id: <290BC37E-3D47-4B0D-8223-7827BE3C02B8@gmail.com>
References: <93057ac3-301d-ed5d-405d-93eb4e3deb30@yuhu.biz> <y2apomdx3pl.fsf@offog.org> <7e3957d4-9729-63cc-dea7-c27e842a6e87@yuhu.biz>
Subject: Re: [kernel-hardening] Legitimate use of /proc/PID/mem,maps and smaps
To: kernel-hardening@lists.openwall.com
Cc: Adam Sampson <ats@offog.org>
List-ID: <kernel-hardening.lists.openwall.com>


--Apple-Mail=_63E99C19-F13F-478C-B53C-4732758A9858
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 2, 2016, at 8:54 PM, Marian Marinov <mm-l@yuhu.biz> wrote:
>=20
> On 11/02/2016 06:10 PM, Adam Sampson wrote:
>> Marian Marinov <mm-l@yuhu.biz> writes:
>>=20
>>> Are there any other legitimate users of these files, maybe X?
>> This is the kind of question that Debian Code Search is useful for
>> (although it's not exhaustive):
>> https://codesearch.debian.net/search?q=3D%2Fproc%2Fself%2Fmem&perpkg=3D=
1
>> https://codesearch.debian.net/search?q=3D%2Fproc%2Fself%2Fmaps&perpkg=3D=
1
>> =
https://codesearch.debian.net/search?q=3D%2Fproc%2Fself%2Fsmaps&perpkg=3D1=

>>=20
>> >=46rom my bug-hunting experience, programs use /proc/self/maps for =
all
>> sorts of weird things -- e.g. working out the full path of the
>> executable, or what version of a shared library they've been linked
>> against, or guessing whether some random value is a valid pointer. =
Many
>> have embedded copies of code from gettext or BinReloc that uses it.
>>=20
>> On the other hand, many of these don't actually need all the =
information
>> in /proc/self/maps, so you could get away with a simplified version =
that
>> only had valid filenames.
>>=20
> Hmm I probably did not explained what I want. I know I can not =
(easily)limit a program to access its own memory(that would be stupid).
>=20
> Pretend that user joe is running top and his top has pid of 1154. Now =
joe runs a php script and that script wants to open /proc/1154/maps and =
so on.
>=20
> I believe that the kernel should not allow the php process(even thou =
it is from the same user to read those files, that are private to the =
top application). Actually I would like to make them invisible for all =
processes and users except the program that is the actual owner of the =
files and privileges users.
>=20
> Does that seam logical to you guys?
>=20
>=20
> Marian


Sounds reasonable. However, this still does not solve the dirty cow case =
where a thread is able to access its own mem to access whatever shared =
by the main thread.

-daveti


--Apple-Mail=_63E99C19-F13F-478C-B53C-4732758A9858
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D"">On Nov 2, 2016, at 8:54 PM, Marian Marinov &lt;<a =
href=3D"mailto:mm-l@yuhu.biz" class=3D"">mm-l@yuhu.biz</a>&gt; wrote:<br =
class=3D""><div><blockquote type=3D"cite" class=3D""><br =
class=3D"Apple-interchange-newline"><div class=3D""><span =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; float: none; display: inline =
!important;" class=3D"">On 11/02/2016 06:10 PM, Adam Sampson =
wrote:</span><br style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><blockquote=
 type=3D"cite" style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D"">Marian =
Marinov &lt;<a href=3D"mailto:mm-l@yuhu.biz" =
class=3D"">mm-l@yuhu.biz</a>&gt; writes:<br class=3D""><br =
class=3D""><blockquote type=3D"cite" class=3D"">Are there any other =
legitimate users of these files, maybe X?<br class=3D""></blockquote>This =
is the kind of question that Debian Code Search is useful for<br =
class=3D"">(although it's not exhaustive):<br class=3D""><a =
href=3D"https://codesearch.debian.net/search?q=3D%2Fproc%2Fself%2Fmem&amp;=
perpkg=3D1" =
class=3D"">https://codesearch.debian.net/search?q=3D%2Fproc%2Fself%2Fmem&a=
mp;perpkg=3D1</a><br =
class=3D"">https://codesearch.debian.net/search?q=3D%2Fproc%2Fself%2Fmaps&=
amp;perpkg=3D1<br =
class=3D"">https://codesearch.debian.net/search?q=3D%2Fproc%2Fself%2Fsmaps=
&amp;perpkg=3D1<br class=3D""><br class=3D"">&gt;=46rom my bug-hunting =
experience, programs use /proc/self/maps for all<br class=3D"">sorts of =
weird things -- e.g. working out the full path of the<br =
class=3D"">executable, or what version of a shared library they've been =
linked<br class=3D"">against, or guessing whether some random value is a =
valid pointer. Many<br class=3D"">have embedded copies of code from =
gettext or BinReloc that uses it.<br class=3D""><br class=3D"">On the =
other hand, many of these don't actually need all the information<br =
class=3D"">in /proc/self/maps, so you could get away with a simplified =
version that<br class=3D"">only had valid filenames.<br class=3D""><br =
class=3D""></blockquote><span style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; float: =
none; display: inline !important;" class=3D"">Hmm I probably did not =
explained what I want. I know I can not (easily)limit a program to =
access its own memory(that would be stupid).</span><br =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px;" class=3D""><br style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: =
0px;" class=3D""><span style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; float: none; display: =
inline !important;" class=3D"">Pretend that user joe is running top and =
his top has pid of 1154. Now joe runs a php script and that script wants =
to open /proc/1154/maps and so on.</span><br style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: =
0px;" class=3D""><br style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><span =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; float: none; display: inline =
!important;" class=3D"">I believe that the kernel should not allow the =
php process(even thou it is from the same user to read those files, that =
are private to the top application). Actually I would like to make them =
invisible for all processes and users except the program that is the =
actual owner of the files and privileges users.</span><br =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px;" class=3D""><br style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: =
0px;" class=3D""><span style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; float: none; display: =
inline !important;" class=3D"">Does that seam logical to you =
guys?</span><br style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px;" class=3D""><br =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px;" class=3D""><br style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: =
0px;" class=3D""><span style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: normal; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; float: none; display: =
inline !important;" class=3D"">Marian</span></div></blockquote></div><div =
class=3D""><br class=3D""></div><div class=3D"">Sounds reasonable. =
However, this still does not solve the dirty cow case where a thread is =
able to access its own mem to access whatever shared by the main =
thread.</div><div class=3D""><br class=3D""></div><div =
class=3D"">-daveti</div><div class=3D""><br =
class=3D""></div></body></html>=

--Apple-Mail=_63E99C19-F13F-478C-B53C-4732758A9858--
