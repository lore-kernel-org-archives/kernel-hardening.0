Return-Path: <SRS0=KOtd=DK=lists.openwall.com=kernel-hardening-return-20089-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F89DC41604
	for <kernel-hardening@archiver.kernel.org>; Sat,  3 Oct 2020 13:47:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EB93D206A1
	for <kernel-hardening@archiver.kernel.org>; Sat,  3 Oct 2020 13:47:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB93D206A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hotmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20089-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20463 invoked by uid 550); 3 Oct 2020 13:47:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8067 invoked from network); 3 Oct 2020 09:43:15 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9e40W97mOA63KdJfNuJRdU6Nz/s5L2p5LxmhThbrWp3ZbjKIB0szKLthLLfLOm+uxvMQ4InpCOhWYxgtv8R9pLrqKMT/dAly2t8IRQsUfXBi9k2v8QtXrnE2jaPu4YRIB5QqOBnDomP/DxbxQx1mPQpApsdW4GXCNKJs+dbdUZdOk/q/zPrHcgFyic36s7OLUbeIAPqPw4Nnz6KmSO7IJ12cXCfR40WV5GPVyeuimiuOAQiFjqk1/EXkQO6dFlWagkTec1/os7bwBBmj8NwDQGpq4JojSVQQCW96FM/y01bRPa6/yXXZ1d/TtF5JqvkIZl5oZlxgn96Nzh9QHL0nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOo7sATSt8hArUeN10urxkOrMpK6CtbMWpdtIRmklS0=;
 b=QZjSjF5KNTDpbE9kQ5UtEB4Y7MsF6tiBE2VnYU67e7HHsG36sSSxYwcP5Nq7pJ16TsiPLuIu4U84aADlTKGNAed6+iURcK52GlkkpGkcT7UFq2NteJayiq1CjiUipzkbHqDUSJcZNb2+MtpFNz2U/ABKQgLwfryaq0L2y7iHK6cG2qWLbBT8yFCaNVU0bodpQQB25Nb1khL08sTaSuXsGB5K49Mpa6l7ILzUikVD/TVI8brA1C6o9U9EYQNES27ixVhYBVr1plFskvjkDiBsnDIRFV7pF7XIP20On62H60CmLH6H995AKhd4ih8l6gI5Z/yV/6DXq0vGjnMYEKfgSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOo7sATSt8hArUeN10urxkOrMpK6CtbMWpdtIRmklS0=;
 b=MnFYd8RRF+sXyKkCiYBEf83Y98SF3D2cRbIvIyJLTrcsOKB/oKE0SWB35cEtjKmZcmJX8WG5R5bTFCc1XIwelVgTg5jC3sK5PdDQEFD41Tos3905fozxTeQRtvfNMRAff4VJ1izHGANlMDaHEYsj88yq5ifI8UJAFjQxW7sfHCburMrOMn2BKzQNDVXwCbN7MriMCJLkGUIQ6ClMi0r47lWpv+BFyxI5hOn3VkyFcHYl7cowRfg/wqQgTRRKnOty8fvKFb3twGMA3nAb1kgUB04p5pkBtnavcighQcQZZH+nkrDuWllSGJ1hkgeKwAM+5i/aLEfwXQ/0TJRKNxIgSQ==
From: Jay K <jayk123@hotmail.com>
To: Florian Weimer <fw@deneb.enyo.de>, "Madhavan T. Venkataraman"
	<madvenka@linux.microsoft.com>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "oleg@redhat.com" <oleg@redhat.com>,
	"mic@digikod.net" <mic@digikod.net>, Arvind Sankar <nivedita@alum.mit.edu>,
	"David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>, "luto@kernel.org"
	<luto@kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-integrity@vger.kernel.org"
	<linux-integrity@vger.kernel.org>, "libffi-discuss@sourceware.org"
	<libffi-discuss@sourceware.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Topic: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Thread-Index:
 AQHWjI6KxyKJbt2Ptk2ZqEdXq+b+vqls92IAgAiGJwCAASXK64ABpRqNgAAH5xCAAasngIAC4oqAgAjazzQ=
Date: Sat, 3 Oct 2020 09:43:02 +0000
Message-ID:
 <CY4PR1401MB1942930DCB5EC5CC62EC3F57E60E0@CY4PR1401MB1942.namprd14.prod.outlook.com>
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
 <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
 <20200923014616.GA1216401@rani.riverdale.lan>
 <20200923091125.GB1240819@rani.riverdale.lan>
 <a742b9cd-4ffb-60e0-63b8-894800009700@linux.microsoft.com>
 <20200923195147.GA1358246@rani.riverdale.lan>
 <2ed2becd-49b5-7e76-9836-6a43707f539f@linux.microsoft.com>
 <87o8luvqw9.fsf@mid.deneb.enyo.de>
 <3fe7ba84-b719-b44d-da87-6eda60543118@linux.microsoft.com>,<fdfe73d3-d735-4bdc-4790-7feb7fecece5@linux.microsoft.com>
In-Reply-To: <fdfe73d3-d735-4bdc-4790-7feb7fecece5@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-incomingtopheadermarker:
 OriginalChecksum:2CF503587D4CBEA3A2C98E5A8F6554AA20B1CEF8FEBA494AE22CBB99A71F4272;UpperCasedChecksum:F06C639AD3AA5DA8D877F3F42646CB2920B1F21C05339E75E57E994AF473819B;SizeAsReceived:8516;Count:44
x-tmn: [IaHxf2lyki2mSv2nMuJqr0FdxBwuSPe31BO5xPXD9iNrGyIpBVge4vF8ZV+PFWEf]
x-ms-publictraffictype: Email
x-incomingheadercount: 44
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 60311b1f-80eb-44dc-a6d4-08d86780b8ba
x-ms-traffictypediagnostic: CY1NAM02HT098:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 2+Z5uLQ7g1VZHgjeR2zw4bw4+tPRzI106iVn0S01IG2IjMhor8HG515INgmE1CsRD59DuWAb9Ps4MFWGEmcb7WPSkmXXKzE+3ZpVzeze0py3q/TfG6nbt3kEOzN/FcoUImN9wtbhUg1qV7KKwLsTb4eWMtlPF9MyrIjqx1xP2rR25hE5BdW5HQAEmDFFZplf4FXkDlDdg7GntPQb3gIltg==
x-ms-exchange-antispam-messagedata:
 LKXLrY5TC1QKA8hS2qUOtsssSM3k+TslMJkhSYJXBwjnuhkA5dBYvJHHLVb0muYQR7Z5TEPUpOhQG81f7ApbykPXgkWbvwZtpAgsWwOrO2x9P7jWnVBI12aeaAU3ACYgcqlZ4bjc4LB17j2Ry+IwNutW55iB+X++hakte6jN13r1PO31wZTVg60VmSivDVf7+1Ld0lA80CokkmCjwOHvgg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hotmail.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-AuthSource: CY1NAM02FT040.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 60311b1f-80eb-44dc-a6d4-08d86780b8ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2020 09:43:02.4940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1NAM02HT098

=A0> And this is not just for libffi that we can somehow do this within lib=
ffi. =0A=
=A0> I would like to provide something so that the maintainers of other =0A=
=A0> dynamic code can use it to convert their dynamic code to static code =
=0A=
=A0> when their dynamic code is a lot more complex that the libffi trampoli=
ne. =0A=
=0A=
=0A=
Having worked on stuff "like" this -- removing "arbitrary" codegen=0A=
from a system and replacing with "templatized" codegen,=0A=
because the runtime banned runtime codegen,=0A=
and despite being a lover of shared source and shared libraries,=0A=
I'm afraid to say, this is not an area very amenable=0A=
to sharing.=0A=
=0A=
Specifically I've done this twice.=0A=
=0A=
=0A=
Providing examples is good and people will copy/paste.=0A=
=0A=
The problem can be sort of split up into parts:=0A=
=0A=
=A0- The management of a pool of thunks.=0A=
=0A=
=A0- The thunks.=0A=
=0A=
Where I mostly give up is:=0A=
=0A=
=A0- Generalizing the thunks, such as to share them.=0A=
=0A=
the management of the pool is kinda sorta generalizable, but the thunks,=0A=
again, it is difficult/impossible to share.=0A=
=0A=
I do think, there is *some* opportunity here.=0A=
=0A=
Stuff like, for some function f(x,y), produce=0A=
a new function f2(y,x) that swaps params and calls f=0A=
or a new function f3(x), that sets y to a constant and calls f.=0A=
=0A=
Like my favorite Scheme-ish:=0A=
=0A=
Given a static binary function:=0A=
=A0 function add(x, y) (+ x y)=0A=
=0A=
Provide for dynamically creating specialized unary functions:=0A=
=0A=
=A0function make-add(x):=0A=
=A0 =A0return function addx(y) (+ x y)=0A=
=0A=
And then generalized to arbitrary rearrangement and hardcoding of parameter=
s.=0A=
=0A=
I believe this is libffi, and might be able to replace some people's codege=
ns.=0A=
=0A=
It sounds a bit contrived, but I know this actually resembles real world ca=
ses.=0A=
=0A=
Consider some library that accepts function pointers but fails to accept=0A=
an additional void* to pass on to them. qsort/bsearch are the classic broke=
n-ish=0A=
cases. Wrapping Windows WNDPROCs in C++ are another -- you want a "thunk" t=
o take=0A=
the Win32-defined parameters, and add a this pointer as well. So you create=
=0A=
a new function and when you create the function you give it the this pointe=
r=0A=
to hardcode within it. i.e. atlthunk.=0A=
=0A=
=A0> The kernel based solution gives you the opportunity to make additional=
=0A=
=A0> security checks at the time a trampoline is invoked. A purely user lev=
el=0A=
=A0> solution cannot do that. E.g., I would like to prevent even the minima=
l=0A=
=A0> trampoline from being used in BOP/ROP chains.=0A=
=0A=
Like what? At some point, it is just normal static code.=0A=
Once libffi is fixed, so that the iOS solution is available on all platform=
s,=0A=
it is all just normal code. There are no checks to apply differently to lib=
ffi=0A=
and its output than any other code, right?=0A=
=A0=0A=
=A0> Before I implement the user land solution recommended by reviewers, I =
just want=0A=
=A0> an opinion on where the code should reside.=0A=
=A0> =0A=
=A0> I am thinking glibc. The other choice would be a separate library, say=
, libtramp.=0A=
=A0> What do you recommend?=0A=
=0A=
What functionality does the user land solution provide?=0A=
=0A=
I suggest, other than lobbying the libffi developers to do their part,=0A=
and perhaps giving in and doing it yourself, identity some other dynamic bu=
t non-arbitrary=0A=
code generations that you wish to fix and work through fixing it.=0A=
See what patterns emerge.=0A=
=0A=
=A0- Jay=0A=
